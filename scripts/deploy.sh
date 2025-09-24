#!/bin/bash

# TaxLien.online - Universal Deployment Script
# Supports both GitHub Actions and GitLab CI/CD

set -e

echo "🚀 TaxLien.online - Universal Deployment"
echo "========================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Detect platform
if [ -d ".github/workflows" ]; then
    PLATFORM="GitHub"
elif [ -f ".gitlab-ci.yml" ]; then
    PLATFORM="GitLab"
else
    echo -e "${RED}❌ No CI/CD platform detected${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Platform: $PLATFORM${NC}"

# Function to trigger GitHub Actions
trigger_github_actions() {
    echo -e "${BLUE}🚀 Triggering GitHub Actions...${NC}"
    
    # Check if we're on a release branch
    CURRENT_BRANCH=$(git branch --show-current)
    
    if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
        echo -e "${GREEN}✅ On main branch, CI/CD will run automatically${NC}"
        echo -e "${BLUE}📱 Check GitHub Actions tab for progress${NC}"
    else
        echo -e "${YELLOW}⚠️  Not on main branch. CI/CD will run on push to main${NC}"
        echo -e "${BLUE}💡 To trigger manually, push to main branch${NC}"
    fi
}

# Function to trigger GitLab CI
trigger_gitlab_ci() {
    echo -e "${BLUE}🚀 Triggering GitLab CI...${NC}"
    
    # Check if we're on a release branch
    CURRENT_BRANCH=$(git branch --show-current)
    
    if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
        echo -e "${GREEN}✅ On main branch, CI/CD will run automatically${NC}"
        echo -e "${BLUE}📱 Check GitLab CI/CD tab for progress${NC}"
    else
        echo -e "${YELLOW}⚠️  Not on main branch. CI/CD will run on push to main${NC}"
        echo -e "${BLUE}💡 To trigger manually, push to main branch${NC}"
    fi
}

# Main deployment logic
case $PLATFORM in
    "GitHub")
        trigger_github_actions
        ;;
    "GitLab")
        trigger_gitlab_ci
        ;;
    *)
        echo -e "${RED}❌ Unsupported platform: $PLATFORM${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}🎉 Deployment initiated!${NC}"
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "${YELLOW}1. Monitor CI/CD pipeline progress${NC}"
echo -e "${YELLOW}2. Check app stores for new releases${NC}"
echo -e "${YELLOW}3. Verify deployment success${NC}"
