global class DX_BusinesHoursHelper {
    @InvocableMethod()
    public static List<Boolean> isWhithin(List<FlowInput> inputs){
        String strTimeZoneBH;
        List<Boolean> lstReturnFlow = new List<Boolean>();
        FlowInput objFlowInput = inputs[0];
        strTimeZoneBH = objFlowInput.TimeZoneBH == 'America/Chicago' ? 'America/Chicago':objFlowInput.TimeZoneBH; 
        Timezone tz = Timezone.getTimeZone( strTimeZoneBH );
		DateTime dt = Datetime.now();
        
        DateTime targetTime = DateTime.ValueOf( dt.addSeconds((tz.getOffset(dt)/1000)));
        Boolean isWithin = BusinessHours.isWithin(objFlowInput.BHId, targetTime);
        lstReturnFlow.add(isWithin);
        System.debug(isWithin);
        return lstReturnFlow;
    }
    
    public class FlowInput {
        @InvocableVariable(label='Record Id Bussines Hours')
        public Id BHId;
        @InvocableVariable(label='Time Zone Bussines Hours')
        public String TimeZoneBH;
    }
}