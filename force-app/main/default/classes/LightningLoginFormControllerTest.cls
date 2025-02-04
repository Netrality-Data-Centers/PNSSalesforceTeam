@IsTest
public with sharing class LightningLoginFormControllerTest {
 
 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void login() {
  String strResult = LightningLoginFormController.login('username', 'password', 'startUrl');
  System.assertNotEquals(strResult, 'username');
 }
 
 @IsTest
 static void getForgotPasswordUrl() {
  LightningLoginFormController.getForgotPasswordUrl();
 }
    
 @IsTest
 static void setExperienceId() {
  String strResult = LightningLoginFormController.setExperienceId('IdTest');
  System.assertNotEquals(strResult, null);
 }
    
 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
  System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }
}