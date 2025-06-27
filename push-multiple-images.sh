#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'aide
show_help() {
    echo "Usage: $0 [OPTIONS] IMAGE1 IMAGE2 ... IMAGEN"
    echo ""
    echo "Push multiple Docker images to Docker Hub"
    echo ""
    echo "Options:"
    echo "  -u, --username USERNAME    Docker Hub username (required if not logged in)"
    echo "  -t, --tag TAG             Tag to apply to all images (default: latest)"
    echo "  -f, --file FILE           Read image names from file (one per line)"
    echo "  -r, --registry REGISTRY   Registry URL (default: docker.io)"
    echo "  -n, --dry-run            Show what would be done without executing"
    echo "  -v, --verbose            Verbose output"
    echo "  -h, --help               Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 -u myuser image1 image2 image3"
    echo "  $0 -u myuser -t v1.0 image1 image2"
    echo "  $0 -f images.txt -u myuser"
    echo ""
}

# Variables par défaut
USERNAME=""
TAG="latest"
REGISTRY="docker.io"
DRY_RUN=false
VERBOSE=false
IMAGE_FILE=""
IMAGES=()

# Fonction de logging
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${BLUE}[VERBOSE]${NC} $1"
    fi
}

# Fonction pour vérifier si Docker est installé et en cours d'exécution
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker n'est pas installé"
        exit 1
    fi

    if ! docker info &> /dev/null; then
        log_error "Docker n'est pas en cours d'exécution"
        exit 1
    fi
}

# Fonction pour vérifier si l'utilisateur est connecté à Docker Hub
check_docker_login() {
    if ! docker info | grep -q "Username"; then
        if [ -z "$USERNAME" ]; then
            log_error "Vous devez être connecté à Docker Hub ou fournir un nom d'utilisateur"
            log "Utilisez 'docker login' ou l'option -u/--username"
            exit 1
        fi
    fi
}

# Fonction pour tagger une image
tag_image() {
    local source_image=$1
    local target_image=$2

    log_verbose "Tagging $source_image as $target_image"

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: docker tag $source_image $target_image"
        return 0
    fi

    if docker tag "$source_image" "$target_image"; then
        log_verbose "Successfully tagged $source_image as $target_image"
        return 0
    else
        log_error "Failed to tag $source_image as $target_image"
        return 1
    fi
}

# Fonction pour pusher une image
push_image() {
    local image=$1

    log "Pushing $image..."

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: docker push $image"
        return 0
    fi

    if docker push "$image"; then
        log_success "Successfully pushed $image"
        return 0
    else
        log_error "Failed to push $image"
        return 1
    fi
}

# Fonction pour lire les images depuis un fichier
read_images_from_file() {
    local file=$1

    if [ ! -f "$file" ]; then
        log_error "File $file not found"
        exit 1
    fi

    while IFS= read -r line; do
        # Ignorer les lignes vides et les commentaires
        if [[ ! -z "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
            IMAGES+=("$line")
        fi
    done < "$file"
}

# Parse des arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--username)
            USERNAME="$2"
            shift 2
            ;;
        -t|--tag)
            TAG="$2"
            shift 2
            ;;
        -f|--file)
            IMAGE_FILE="$2"
            shift 2
            ;;
        -r|--registry)
            REGISTRY="$2"
            shift 2
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            log_error "Unknown option $1"
            show_help
            exit 1
            ;;
        *)
            IMAGES+=("$1")
            shift
            ;;
    esac
done

# Vérifications préliminaires
check_docker

# Lire les images depuis un fichier si spécifié
if [ ! -z "$IMAGE_FILE" ]; then
    read_images_from_file "$IMAGE_FILE"
fi

# Vérifier qu'on a au moins une image
if [ ${#IMAGES[@]} -eq 0 ]; then
    log_error "Aucune image spécifiée"
    show_help
    exit 1
fi

# Vérifier la connexion Docker Hub
check_docker_login

# Afficher le résumé
log "=== RÉSUMÉ ==="
log "Registry: $REGISTRY"
log "Tag: $TAG"
log "Images à traiter: ${#IMAGES[@]}"
if [ "$VERBOSE" = true ]; then
    for img in "${IMAGES[@]}"; do
        log_verbose "  - $img"
    done
fi
if [ "$DRY_RUN" = true ]; then
    log_warning "MODE DRY RUN - Aucune action ne sera effectuée"
fi
echo ""

# Demander confirmation
if [ "$DRY_RUN" = false ]; then
    read -p "Continuer ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Opération annulée"
        exit 0
    fi
fi

# Traitement des images
SUCCESS_COUNT=0
FAILED_IMAGES=()

log "=== DÉBUT DU TRAITEMENT ==="

for image in "${IMAGES[@]}"; do
    log "Processing image: $image"

    # Déterminer le nom de l'image de destination
    if [ ! -z "$USERNAME" ]; then
        target_image="$REGISTRY/$USERNAME/$image:$TAG"
    else
        # Si pas de username fourni, on assume que l'image a déjà le bon format
        target_image="$image:$TAG"
    fi

    log_verbose "Target image: $target_image"

    # Tagger l'image si nécessaire
    if [ "$image:$TAG" != "$target_image" ]; then
        if ! tag_image "$image:$TAG" "$target_image"; then
            FAILED_IMAGES+=("$image")
            continue
        fi
    fi

    # Pusher l'image
    if push_image "$target_image"; then
        ((SUCCESS_COUNT++))
    else
        FAILED_IMAGES+=("$image")
    fi

    echo ""
done

# Résumé final
log "=== RÉSUMÉ FINAL ==="
log_success "Images pushées avec succès: $SUCCESS_COUNT/${#IMAGES[@]}"

if [ ${#FAILED_IMAGES[@]} -gt 0 ]; then
    log_error "Images échouées: ${#FAILED_IMAGES[@]}"
    for failed_img in "${FAILED_IMAGES[@]}"; do
        log_error "  - $failed_img"
    done
    exit 1
else
    log_success "Toutes les images ont été pushées avec succès!"
fi
