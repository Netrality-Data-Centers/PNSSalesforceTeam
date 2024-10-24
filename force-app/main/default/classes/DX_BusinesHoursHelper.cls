global class DX_BusinesHoursHelper {
    @InvocableMethod()
    public static List<Boolean> isWhithin(List<FlowInput> inputs){
        String strTimeZoneBH;
        List<Boolean> lstReturnFlow = new List<Boolean>();
        FlowInput objFlowInput = inputs[0];
        Boolean isWithin = BusinessHours.isWithin(objFlowInput.BHId, Datetime.now());
        lstReturnFlow.add(isWithin);
        System.debug(isWithin);
        return lstReturnFlow;
    }
    
    public class FlowInput {
        @InvocableVariable(label='Record Id Bussines Hours')
        public Id BHId;
    }
}