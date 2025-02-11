public class DX_TenantIdHelper {
    @InvocableMethod()
    public static List<String> generateTenantId(List<FlowInput> inputs) {
        List<String> result = new List<String>();
        
        String accountId = Id.valueOf(inputs.get(0).accountId);
        String accountName = inputs.get(0).accountName.replaceAll('[^a-zA-Z0-9\\s+]', '');
        
        String concatenatedString = accountName.substring(0, 3) + accountId.substring(accountId.length() - 2, accountId.length());
        result.add(concatenatedString);
        
        return result;
    }
    
    public class FlowInput {
        @InvocableVariable(label='Account Id')
        public Id accountId;
        
        @InvocableVariable(label='Account Name')
        public String accountName;
    }
}