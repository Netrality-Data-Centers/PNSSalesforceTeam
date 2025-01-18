/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 11-08-2024
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
public class DX_viewOpenServiceRequest_ctr {
    @AuraEnabled(cacheable=true)
    public static List<Case> getOpenServiceRequest() {
        List<Case> lstCase = new List<Case>();
        String IdUser = UserInfo.getUserId();
        String ContactId = getUserInfo(IdUser);
        If(!String.isBlank(ContactId)){
            String AccountId = getContactInfo(ContactId);
            if(!String.isBlank(AccountId)){
                lstCase = getOpenSR(AccountId);
            }
        }
        return lstCase;
    }
    
    public static String getUserInfo(String UserId){
        List<User> lstUser = [SELECT Id, ContactId FROM User WHERE Id =: UserId Limit 1];
        return lstUser[0].ContactId;
    }
    
    public static String getContactInfo(String ContactId){
        List<Contact> lstContact = [SELECT Id, AccountId FROM Contact WHERE Id =: ContactId Limit 1];
        return lstContact[0].AccountId;
    }
    
    public static List<Case> getOpenSR(String AccountId){
        List<Case> lstCase = [SELECT Id, CaseNumber, RecordType.Name, Type, Status, DX_Site__c, CreatedDate  
                              FROM   Case 
                              WHERE  AccountId =: AccountId 
                              AND    (Status = 'On Hold'
                              OR	  Status = 'New'
                              OR	  Status = 'In Progress'
                              OR	  Status = 'Resolved') 
                              AND 	 (RecordType.DeveloperName = 'DX_Access_Request'
                              OR   	  RecordType.DeveloperName = 'DX_Accounting_Request'
                              OR   	  RecordType.DeveloperName = 'DX_Contracts_Request'
                              OR   	  RecordType.DeveloperName = 'DX_Cross_Connect'
                              OR   	  RecordType.DeveloperName = 'DX_Customer_Experience_Request'
                              OR   	  RecordType.DeveloperName = 'DX_Logistics'
                              OR   	  RecordType.DeveloperName = 'DX_Remote_Hands_Support') 
                              ORDER BY CaseNumber DESC];
        return lstCase;
    }
}