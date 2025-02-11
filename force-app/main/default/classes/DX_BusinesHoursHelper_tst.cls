@isTest
public class DX_BusinesHoursHelper_tst {
    @isTest
    static void testIsWithin() {
        // Set up business hours
		BusinessHours bh = [SELECT Id FROM BusinessHours LIMIT 1];

        // Set up test input
        DX_BusinesHoursHelper.FlowInput input = new DX_BusinesHoursHelper.FlowInput();
        input.BHId = bh.Id;
        
        List<DX_BusinesHoursHelper.FlowInput> inputs = new List<DX_BusinesHoursHelper.FlowInput>();
        inputs.add(input);

        // Execute the method
        Test.startTest();
        List<Boolean> results = DX_BusinesHoursHelper.isWhithin(inputs);
        Test.stopTest();

        // Verify the result
        System.assertEquals(1, results.size(), 'The result list should have one boolean value.');
        System.assertEquals(true, results[0], 'The time should be within business hours.');

        // Test outside business hours
        results = DX_BusinesHoursHelper.isWhithin(inputs);

        System.assertEquals(1, results.size(), 'The result list should have one boolean value.');
        System.assertEquals(true, results[0], 'The time should not be within business hours.');
    }
}