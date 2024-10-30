public class DX_PrimaryAccountContactHelper {

    @InvocableMethod()
    public static List<Id> getPrimaryAccountforContact(List<FlowInput> inputs){
        List<Id> listOfAccountIds = new List<Id>();
        Id aContactId = inputs.get(0).contactId;
        for(Account accObj : [select id, (select id from AccountContactRelations where contactId=:aContactId and TOLABEL(Roles)='Primary Contact') from Account]){
            if(accObj.AccountContactRelations.size()>0){
                listOfAccountIds.add(accObj.id);
            }
        } 
        return listOfAccountIds;
    }
    
    public class FlowInput {
        @InvocableVariable(label='Contact Id')
        public Id contactId;
    }
}