public with sharing class DX_DCIM_ActionHelper {
    /**
     * @description A class that is used to store request parameters: methodName, buildingId
     */
    public class FlowInputs {

        @InvocableVariable(label='Method Name' description='Defines the method you wish to run')
        public String methodName;

        @InvocableVariable(label='buildingId' description='A Building Id to fetch data based on this')
        public String buildingId;

        @InvocableVariable(label='accountId' description='A Account Id to fetch data based on this')
        public String accountId;

    }

    /**
     * @description A class that is used to store responses from queries
     */
    public class FlowOutputs {

        @InvocableVariable(label='Data Halls by Building' description='Data Halls by Building')
        public List<DX_DCIMChoiceResource> dataHallsByBuildingList;

        @InvocableVariable(label='POEAllocations by Building' description='POEAllocations by Building')
        public List<DX_DCIMChoiceResource> poeAllocationsByBuildingList;

        @InvocableVariable(label='TenantSuites by Building' description='TenantSuites by Building')
        public List<DX_DCIMChoiceResource> tenantSuitesByBuildingList;

        @InvocableVariable(label='Cabinets by Building and Account' description='Cabinets by Building and Account')
        public List<DX_DCIMChoiceResource> cabinetsByBuildingAndAccountList;

        @InvocableVariable(label='Floors by Building' description='Floors by Building')
        public List<DX_DCIMChoiceResource> floorsByBuildingList;

    }

    /**
    * @description main execute method
    * @param flowInputs class that contains all the input params from the flow
    * @return List<FlowOutputs>
    **/
    @InvocableMethod (
        description ='Runs method depending on param'
        label='DCIM Action Helper'
        category='Utility'
        iconName='slds:standard:record_create'
    )
    public static List<FlowOutputs> execute(List<FlowInputs> flowInputs) {

        FlowOutputs output = new FlowOutputs();
        List<FlowOutputs> results = new List<FlowOutputs>();

        for (FlowInputs fi: flowInputs) {

            switch on fi.methodName {

                when 'getDataHallsByBuilding' {

                    output.dataHallsByBuildingList = getDataHallsByBuilding(fi.buildingId);

                }

                when 'getPOEAllocationsByBuilding' {

                    output.poeAllocationsByBuildingList = getPOEAllocationsByBuilding(fi.buildingId);

                }
                when 'getTenantSuitesByBuilding' {

                    output.tenantSuitesByBuildingList = getTenantSuitesByBuilding(fi.buildingId);

                }
                when 'getCabinetsByBuildingAndAccount' {

                    output.cabinetsByBuildingAndAccountList = getCabinetsByBuildingAndAccount(fi.buildingId, fi.accountId);

                }
                when 'getFloorsByBuilding' {

                    output.floorsByBuildingList = getFloorsByBuilding(fi.buildingId);

                }

            }

        }
        results.add(output);
        return results;

    }

    private static DX_DCIMChoiceResource createChoiceResourceItem(String value, String label) {
        DX_DCIMChoiceResource choiceResourceItem = new DX_DCIMChoiceResource();
        choiceResourceItem.value = value;
        choiceResourceItem.label = label;
        return choiceResourceItem;
    }

    private static List<DX_DCIMChoiceResource> getDataHallsByBuilding(Id buildingId) {
        List<DX_DCIMChoiceResource> dataHallsByBuildingList = new List<DX_DCIMChoiceResource>();
        List<DC_Data_Hall__c> dataHalls = new DX_DCIM_DataAccess().getDataHallsByBuilding(buildingId);
        if(!dataHalls.isEmpty()){
            for(DC_Data_Hall__c item : dataHalls){
                DX_DCIMChoiceResource choiceResourceItem = createChoiceResourceItem(item.Id, item.Name);
                dataHallsByBuildingList.add(choiceResourceItem);
            }
        }
        return dataHallsByBuildingList;

    }

    private static List<DX_DCIMChoiceResource> getPOEAllocationsByBuilding(Id buildingId) {
        List<DX_DCIMChoiceResource> poeAllocationsByBuildingList = new List<DX_DCIMChoiceResource>();
        List<DC_POE_Allocation__c> poeAllocations = new DX_DCIM_DataAccess().getPoeAllocationsByBuilding(buildingId);
        if(!poeAllocations.isEmpty()){
            for(DC_POE_Allocation__c item : poeAllocations){
                DX_DCIMChoiceResource choiceResourceItem = createChoiceResourceItem(item.Id, item.Name);
                poeAllocationsByBuildingList.add(choiceResourceItem);
            }
            
        }
        return poeAllocationsByBuildingList;
    }

    private static List<DX_DCIMChoiceResource> getTenantSuitesByBuilding(Id buildingId) {
        List<DX_DCIMChoiceResource> tenantSuitesByBuildingList = new List<DX_DCIMChoiceResource>();
        List<DC_Tenant_Suite__c> tenantSuites = new DX_DCIM_DataAccess().getTenantSuitesByBuilding(buildingId);
        if(!tenantSuites.isEmpty()){
            for(DC_Tenant_Suite__c item : tenantSuites){
                DX_DCIMChoiceResource choiceResourceItem = createChoiceResourceItem(item.Id, item.Name);
                tenantSuitesByBuildingList.add(choiceResourceItem);
            }
        }
        return tenantSuitesByBuildingList;
    }

    private static List<DX_DCIMChoiceResource> getCabinetsByBuildingAndAccount(Id buildingId, Id accountId) {
        List<DX_DCIMChoiceResource> cabinetsByBuildingAndAccountList = new List<DX_DCIMChoiceResource>();
        List<DC_Cabinet__c> cabinets = new DX_DCIM_DataAccess().getCabinetsByBuildingAndAccount(buildingId, accountId);
        if(!cabinets.isEmpty()){
            for(DC_Cabinet__c item : cabinets){
                DX_DCIMChoiceResource choiceResourceItem = createChoiceResourceItem(item.Id, item.Name);
                cabinetsByBuildingAndAccountList.add(choiceResourceItem);
            }
        }
        return cabinetsByBuildingAndAccountList;
    }

    private static List<DX_DCIMChoiceResource> getFloorsByBuilding(Id buildingId) {
        List<DX_DCIMChoiceResource> floorsByBuildingList = new List<DX_DCIMChoiceResource>();
        List<DC_Floor__c> floors = DX_DCIM_DataAccess.getFloors(buildingId);
        if(!floors.isEmpty()){
            for(DC_Floor__c item : floors){
                DX_DCIMChoiceResource choiceResourceItem = createChoiceResourceItem(item.Id, item.Name);
                floorsByBuildingList.add(choiceResourceItem);
            }
            
        }
        return floorsByBuildingList;
    }
}