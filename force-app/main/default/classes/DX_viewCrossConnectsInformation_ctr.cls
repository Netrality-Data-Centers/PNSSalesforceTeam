/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 11-01-2024
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
public class DX_viewCrossConnectsInformation_ctr {
    @AuraEnabled(cacheable=true)
    public static List<DC_Cross_Connect__c> getCrossConnets() {
        List<DC_Cross_Connect__c> lstCrossConnect = new List<DC_Cross_Connect__c>();
        String IdUser = UserInfo.getUserId();
        String ContactId = getUserInfo(IdUser);
        If(!String.isBlank(ContactId)){
            String AccountId = getContactInfo(ContactId);
            if(!String.isBlank(AccountId)){
                lstCrossConnect = getCrossConnectInfo(AccountId);
            }
        }
        return lstCrossConnect;
    }
    
    public static String getUserInfo(String UserId){
        List<User> lstUser = [SELECT Id, ContactId FROM User WHERE Id =: UserId Limit 1];
        return lstUser[0].ContactId;
    }
    
    public static String getContactInfo(String ContactId){
        List<Contact> lstContact = [SELECT Id, AccountId FROM Contact WHERE Id =: ContactId Limit 1];
        return lstContact[0].AccountId;
    }
    
    public static List<DC_Cross_Connect__c> getCrossConnectInfo(String AccountId){
        List<DC_Cross_Connect__c> lstCrossConnect = [SELECT Id, 
                                                            Name,
                                                            Building__r.Name,
                                                            Origination_Account__r.Name,
                                                            Destination_Account__r.Name,
                                                            Xconnect_Status__c  
                                                     FROM 	DC_Cross_Connect__c 
                                                     WHERE 	Origination_Account__c =: AccountId
                                                     OR		Destination_Account__c =: AccountId];
        return lstCrossConnect;
    }
}