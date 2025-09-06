#!/bin/bash

# TaxLien.online - Quick Deploy Script
# Universal deployment script for both GitHub Actions and GitLab CI/CD

set -e

echo "🚀 TaxLien.online - Quick Deploy"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="TaxLien.online"
PACKAGE_NAME="taxlien.online"

# Function to detect CI/CD platform
detect_platform() {
    if [ -d ".github/workflows" ]; then
        echo "GitHub"
    elif [ -f ".gitlab-ci.yml" ]; then
        echo "GitLab"
    elif [ -d ".github" ]; then
        echo "GitHub"
    else
        echo "Unknown"
    fi
}

# Function to check if we're on a release branch
check_release_branch() {
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ] || [ "$CURRENT_BRANCH" = "develop" ]; then
        return 0
    else
        return 1
    fi
}

# Function to check if we have a release tag
check_release_tag() {
    if git describe --tags --exact-match HEAD 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to run deployment readiness check
run_readiness_check() {
    echo -e "${BLUE}🔍 Running deployment readiness check...${NC}"
    
    if [ -f "scripts/check-deployment-ready.sh" ]; then
        chmod +x scripts/check-deployment-ready.sh
        ./scripts/check-deployment-ready.sh
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Deployment readiness check passed${NC}"
            return 0
        else
            echo -e "${RED}❌ Deployment readiness check failed${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  Deployment readiness check script not found${NC}"
        echo -e "${BLUE}💡 Skipping readiness check${NC}"
        return 0
    fi
}

# Function to setup CI/CD if not already done
setup_cicd_if_needed() {
    echo -e "${BLUE}🔧 Checking CI/CD setup...${NC}"
    
    if [ ! -f ".env.secrets.template" ] && [ ! -d ".github/workflows" ] && [ ! -f ".gitlab-ci.yml" ]; then
        echo -e "${YELLOW}⚠️  CI/CD not set up. Setting up now...${NC}"
        
        if [ -f "scripts/setup-ci-cd.sh" ]; then
            chmod +x scripts/setup-ci-cd.sh
            ./scripts/setup-ci-cd.sh
        else
            echo -e "${RED}❌ CI/CD setup script not found${NC}"
            echo -e "${BLUE}💡 Please run: ./scripts/setup-ci-cd.sh manually${NC}"
            return 1
        fi
    else
        echo -e "${GREEN}✅ CI/CD already set up${NC}"
    fi
    
    return 0
}

# Function to trigger GitHub Actions deployment
trigger_github_deployment() {
    echo -e "${BLUE}🚀 Triggering GitHub Actions deployment...${NC}"
    
    # Check if we're on a release branch
    if check_release_branch; then
        echo -e "${GREEN}✅ On release branch, CI/CD will run automatically${NC}"
        echo -e "${BLUE}📱 Check GitHub Actions tab for progress: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git.*/\1/')/actions${NC}"
    else
        echo -e "${YELLOW}⚠️  Not on release branch (main/master/develop)${NC}"
        echo -e "${BLUE}💡 To trigger deployment, push to main branch:${NC}"
        echo -e "${YELLOW}   git checkout main${NC}"
        echo -e "${YELLOW}   git merge $(git branch --show-current)${NC}"
        echo -e "${YELLOW}   git push origin main${NC}"
    fi
}

# Function to trigger GitLab CI deployment
trigger_gitlab_deployment() {
    echo -e "${BLUE}🚀 Triggering GitLab CI deployment...${NC}"
    
    # Check if we're on a release branch
    if check_release_branch; then
        echo -e "${GREEN}✅ On release branch, CI/CD will run automatically${NC}"
        echo -e "${BLUE}📱 Check GitLab CI/CD tab for progress${NC}"
    else
        echo -e "${YELLOW}⚠️  Not on release branch (main/master/develop)${NC}"
        echo -e "${BLUE}💡 To trigger deployment, push to main branch:${NC}"
        echo -e "${YELLOW}   git checkout main${NC}"
        echo -e "${YELLOW}   git merge $(git branch --show-current)${NC}"
        echo -e "${YELLOW}   git push origin main${NC}"
    fi
}

# Function to create and push release tag
create_release_tag() {
    echo -e "${BLUE}🏷️  Creating release tag...${NC}"
    
    # Get current version from pubspec.yaml
    VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
    
    if [ -z "$VERSION" ]; then
        echo -e "${RED}❌ Could not determine version from pubspec.yaml${NC}"
        return 1
    fi
    
    TAG_NAME="v$VERSION"
    
    # Check if tag already exists
    if git tag -l | grep -q "^$TAG_NAME$"; then
        echo -e "${YELLOW}⚠️  Tag $TAG_NAME already exists${NC}"
        read -p "Do you want to delete and recreate it? (y/n): " recreate
        if [ "$recreate" = "y" ] || [ "$recreate" = "Y" ]; then
            git tag -d "$TAG_NAME"
            git push origin ":refs/tags/$TAG_NAME" 2>/dev/null || true
        else
            echo -e "${BLUE}💡 Using existing tag${NC}"
            return 0
        fi
    fi
    
    # Create and push tag
    git tag -a "$TAG_NAME" -m "Release $TAG_NAME - $PROJECT_NAME"
    git push origin "$TAG_NAME"
    
    echo -e "${GREEN}✅ Release tag $TAG_NAME created and pushed${NC}"
    return 0
}

# Function to show deployment status
show_deployment_status() {
    local platform=$1
    
    echo ""
    echo -e "${BLUE}📊 Deployment Status${NC}"
    echo "===================="
    echo -e "Platform: ${GREEN}$platform${NC}"
    echo -e "Project: ${GREEN}$PROJECT_NAME${NC}"
    echo -e "Package: ${GREEN}$PACKAGE_NAME${NC}"
    
    if check_release_tag; then
        TAG=$(git describe --tags --exact-match HEAD)
        echo -e "Tag: ${GREEN}$TAG${NC}"
    else
        echo -e "Tag: ${YELLOW}No release tag${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}📋 What happens next:${NC}"
    echo -e "${YELLOW}1. CI/CD pipeline will build the app${NC}"
    echo -e "${YELLOW}2. Android AAB will be uploaded to Google Play Store${NC}"
    echo -e "${YELLOW}3. iOS IPA will be uploaded to App Store Connect${NC}"
    echo -e "${YELLOW}4. Release will be created with download links${NC}"
    echo ""
    echo -e "${BLUE}⏱️  Expected timeline:${NC}"
    echo -e "${YELLOW}- Build: 5-10 minutes${NC}"
    echo -e "${YELLOW}- Google Play: 1-3 hours for review${NC}"
    echo -e "${YELLOW}- App Store: 1-7 days for review${NC}"
}

# Main deployment function
main() {
    echo -e "${BLUE}🔍 Detecting CI/CD platform...${NC}"
    
    PLATFORM=$(detect_platform)
    
    if [ "$PLATFORM" = "Unknown" ]; then
        echo -e "${RED}❌ No CI/CD platform detected${NC}"
        echo -e "${BLUE}💡 Please run: ./scripts/setup-ci-cd.sh first${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Detected platform: $PLATFORM${NC}"
    
    # Run deployment readiness check
    if ! run_readiness_check; then
        echo -e "${RED}❌ Deployment readiness check failed${NC}"
        echo -e "${BLUE}💡 Please fix the issues and try again${NC}"
        exit 1
    fi
    
    # Setup CI/CD if needed
    if ! setup_cicd_if_needed; then
        echo -e "${RED}❌ CI/CD setup failed${NC}"
        exit 1
    fi
    
    # Ask user what they want to do
    echo ""
    echo -e "${BLUE}🎯 What would you like to do?${NC}"
    echo -e "${YELLOW}1. Deploy current branch (if on main/master/develop)${NC}"
    echo -e "${YELLOW}2. Create release tag and deploy${NC}"
    echo -e "${YELLOW}3. Just show deployment status${NC}"
    echo -e "${YELLOW}4. Exit${NC}"
    
    read -p "Choose option (1-4): " choice
    
    case $choice in
        1)
            echo -e "${BLUE}🚀 Deploying current branch...${NC}"
            if [ "$PLATFORM" = "GitHub" ]; then
                trigger_github_deployment
            elif [ "$PLATFORM" = "GitLab" ]; then
                trigger_gitlab_deployment
            fi
            show_deployment_status "$PLATFORM"
            ;;
        2)
            echo -e "${BLUE}🏷️  Creating release tag and deploying...${NC}"
            if create_release_tag; then
                if [ "$PLATFORM" = "GitHub" ]; then
                    trigger_github_deployment
                elif [ "$PLATFORM" = "GitLab" ]; then
                    trigger_gitlab_deployment
                fi
                show_deployment_status "$PLATFORM"
            else
                echo -e "${RED}❌ Failed to create release tag${NC}"
                exit 1
            fi
            ;;
        3)
            show_deployment_status "$PLATFORM"
            ;;
        4)
            echo -e "${BLUE}👋 Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}🎉 Deployment process initiated!${NC}"
    echo -e "${BLUE}📱 Monitor your CI/CD platform for progress${NC}"
}

# Run main function
main
