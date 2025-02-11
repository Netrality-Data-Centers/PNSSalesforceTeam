public class DX_RelatedAccountsContactHelper {

    @InvocableMethod()
    public static List<List<Id>> getRelatedAccountsforContact(List<FlowInput> inputs){
        List<List<Id>> lstReturn = new List<List<Id>>();
        List<Id> listOfAccountIds = new List<Id>();
        Id aContactId = inputs.get(0).contactId;
        for(Account accObj : [select id, (select id from AccountContactRelations where contactId=:aContactId) from Account]){
            if(accObj.AccountContactRelations.size()>0){
                listOfAccountIds.add(accObj.id);
            }
        } 
        lstReturn.add(listOfAccountIds);
        return lstReturn;
    }
    
    public class FlowInput {
        @InvocableVariable(label='Contact Id')
        public Id contactId;
    }
}