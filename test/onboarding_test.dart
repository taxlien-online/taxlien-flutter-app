import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freedome_manager/services/onboarding_service.dart';
import 'package:freedome_manager/services/localization_service.dart';
import 'package:freedome_manager/services/theme_service.dart';

void main() {
  group('OnboardingService Tests', () {
    late OnboardingService onboardingService;
    late LocalizationService localizationService;
    late ThemeService themeService;

    setUp(() {
      onboardingService = OnboardingService();
      localizationService = LocalizationService();
      themeService = ThemeService();
    });

    test('Onboarding service should have correct initial state', () {
      // Assert - Initial state should be correct
      expect(onboardingService.currentStep, 0);
      expect(onboardingService.totalSteps, 6);
      expect(onboardingService.isFirstStep, true);
      expect(onboardingService.isLastStep, false);
      expect(onboardingService.canGoNext, true);
      expect(onboardingService.canGoPrevious, false);
      expect(onboardingService.isOnboardingCompleted, false);
      expect(onboardingService.isOnboardingSkipped, false);
    });

    test('Onboarding service should handle step navigation', () async {
      // Act - Navigate to next step
      await onboardingService.nextStep();
      
      // Assert - Should be on step 1
      expect(onboardingService.currentStep, 1);
      expect(onboardingService.isFirstStep, false);
      expect(onboardingService.canGoPrevious, true);
      expect(onboardingService.canGoNext, true);
      
      // Act - Navigate back
      await onboardingService.previousStep();
      
      // Assert - Should be back on step 0
      expect(onboardingService.currentStep, 0);
      expect(onboardingService.isFirstStep, true);
      expect(onboardingService.canGoPrevious, false);
    });

    test('Onboarding service should handle completion', () async {
      // Act - Complete onboarding
      await onboardingService.completeOnboarding();
      
      // Assert - Should be completed
      expect(onboardingService.isOnboardingCompleted, true);
      expect(onboardingService.isOnboardingSkipped, false);
      expect(onboardingService.currentStep, 0);
    });

    test('Onboarding service should handle skipping', () async {
      // Act - Skip onboarding
      await onboardingService.skipOnboarding();
      
      // Assert - Should be skipped
      expect(onboardingService.isOnboardingSkipped, true);
      expect(onboardingService.isOnboardingCompleted, true);
      expect(onboardingService.currentStep, 0);
    });

    test('Onboarding service should validate step boundaries', () async {
      // Act - Try to go to invalid step
      await onboardingService.setCurrentStep(-1);
      expect(onboardingService.currentStep, 0); // Should stay at 0
      
      await onboardingService.setCurrentStep(10);
      expect(onboardingService.currentStep, 0); // Should stay at 0
      
      // Act - Go to valid step
      await onboardingService.setCurrentStep(2);
      expect(onboardingService.currentStep, 2);
    });

    test('Onboarding service should provide correct step info', () {
      // Act
      final stepInfo = onboardingService.getCurrentStepInfo();
      
      // Assert
      expect(stepInfo['step'], 0);
      expect(stepInfo['totalSteps'], 6);
      expect(stepInfo['progress'], 0.0);
      expect(stepInfo['isFirst'], true);
      expect(stepInfo['isLast'], false);
      expect(stepInfo['canGoNext'], true);
      expect(stepInfo['canGoPrevious'], false);
    });

    test('Onboarding service should handle last step correctly', () async {
      // Act - Go to last step
      await onboardingService.setCurrentStep(5);
      
      // Assert
      expect(onboardingService.currentStep, 5);
      expect(onboardingService.isLastStep, true);
      expect(onboardingService.isFirstStep, false);
      expect(onboardingService.canGoNext, false);
      expect(onboardingService.canGoPrevious, true);
    });

    test('Onboarding service should handle progress calculation', () async {
      // Initial progress should be 0
      expect(onboardingService.progress, 0.0);
      
      // Go to middle step
      await onboardingService.setCurrentStep(3);
      expect(onboardingService.progress, 0.6); // 3/5 = 0.6
      
      // Go to last step
      await onboardingService.setCurrentStep(5);
      expect(onboardingService.progress, 1.0); // 5/5 = 1.0
    });

    test('Onboarding service should handle status correctly', () async {
      // Initial status
      expect(onboardingService.status, 'in_progress');
      
      // After completion
      await onboardingService.completeOnboarding();
      expect(onboardingService.status, 'completed');
      
      // Reset and skip
      await onboardingService.resetOnboarding();
      await onboardingService.skipOnboarding();
      expect(onboardingService.status, 'skipped');
    });

    test('Onboarding service should handle navigation guards', () async {
      // Should not be able to go previous from first step
      await onboardingService.previousStep();
      expect(onboardingService.currentStep, 0);
      
      // Should not be able to go next from last step
      await onboardingService.setCurrentStep(5);
      await onboardingService.nextStep();
      expect(onboardingService.currentStep, 5);
    });

    test('Onboarding service should handle reset correctly', () async {
      // Arrange - Set some state
      await onboardingService.setCurrentStep(3);
      await onboardingService.completeOnboarding();
      
      // Act - Reset
      await onboardingService.resetOnboarding();
      
      // Assert - Should be back to initial state
      expect(onboardingService.currentStep, 0);
      expect(onboardingService.isOnboardingCompleted, false);
      expect(onboardingService.isOnboardingSkipped, false);
      expect(onboardingService.isFirstStep, true);
      expect(onboardingService.canGoNext, true);
    });

    test('Onboarding service should handle shouldShowOnboarding correctly', () async {
      // Initially should show onboarding
      expect(onboardingService.shouldShowOnboarding(), true);
      
      // After completion, should not show (because version is set to '1.0.0')
      await onboardingService.completeOnboarding();
      expect(onboardingService.shouldShowOnboarding(), false);
      
      // Reset and should show again
      await onboardingService.resetOnboarding();
      expect(onboardingService.shouldShowOnboarding(), true);
    });

    test('Onboarding service should handle wasOnboardingSkipped correctly', () async {
      // Initially not skipped
      expect(onboardingService.wasOnboardingSkipped(), false);
      
      // After skipping
      await onboardingService.skipOnboarding();
      expect(onboardingService.wasOnboardingSkipped(), true);
      
      // After completion (not skipped)
      await onboardingService.resetOnboarding();
      await onboardingService.completeOnboarding();
      expect(onboardingService.wasOnboardingSkipped(), false);
    });

    test('Onboarding service should handle canShowSkip correctly', () {
      // Should show skip on first step
      expect(onboardingService.canShowSkip(0), true);
      
      // Should show skip on middle step
      expect(onboardingService.canShowSkip(3), true);
      
      // Should not show skip on last step
      expect(onboardingService.canShowSkip(5), false);
    });

    test('Onboarding service should handle canCompleteOnboarding correctly', () async {
      // Should not be able to complete on first step
      expect(onboardingService.canCompleteOnboarding, false);
      
      // Should be able to complete on last step
      await onboardingService.setCurrentStep(5);
      expect(onboardingService.canCompleteOnboarding, true);
    });

    test('Onboarding service should handle canSkipOnboarding correctly', () async {
      // Should be able to skip on first step
      expect(onboardingService.canSkipOnboarding, true);
      
      // Should not be able to skip on last step
      await onboardingService.setCurrentStep(5);
      expect(onboardingService.canSkipOnboarding, false);
    });
  });
} 