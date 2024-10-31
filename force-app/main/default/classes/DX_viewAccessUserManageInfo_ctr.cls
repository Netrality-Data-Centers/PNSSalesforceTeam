public class DX_viewAccessUserManageInfo_ctr {
	@AuraEnabled(cacheable=true)
    public static List<DX_Access_Managment__c> getAccessUserManageInfo() {
        List<DX_Access_Managment__c> lstAccessManage = new List<DX_Access_Managment__c>();
        String IdUser = UserInfo.getUserId();
        String ContactId = getUserInfo(IdUser);
        If(!String.isBlank(ContactId)){
            String AccountId = getContactInfo(ContactId);
            if(!String.isBlank(AccountId)){
                lstAccessManage = getAccessManageInfo(AccountId);
            }
        }
        return lstAccessManage;
    }
    
    public static String getUserInfo(String UserId){
        List<User> lstUser = [SELECT Id, ContactId FROM User WHERE Id =: UserId Limit 1];
        return lstUser[0].ContactId;
    }
    
    public static String getContactInfo(String ContactId){
        List<Contact> lstContact = [SELECT Id, AccountId FROM Contact WHERE Id =: ContactId Limit 1];
        return lstContact[0].AccountId;
    }
    
    public static List<DX_Access_Managment__c> getAccessManageInfo(String AccountId){
        List<DX_Access_Managment__c> lstAccessManage = [SELECT Id, 
                                                               Contact_Name__r.Name,
                                                               Position_Role__c,
                                                               Account_Name__r.Name
                                                        FROM   DX_Access_Managment__c 
                                                        WHERE  Contact_Name__r.AccountId =: AccountId];
        return lstAccessManage;
    }
}