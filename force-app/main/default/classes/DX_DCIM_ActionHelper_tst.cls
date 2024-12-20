/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 12-20-2024
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
@IsTest
public with sharing class DX_DCIM_ActionHelper_tst {
    @testSetup
    static void setup() {
        Account Account = new Account(Name = 'Test Account');
        insert Account;

        // Create a new Building__c record
        Building__c building = new Building__c(Name = 'Test Building');
        insert building;

        // Create a new DC_Floor__c record
        DC_Floor__c Floor = new DC_Floor__c(Name = 'Test Floor', Building__c = building.Id , Floor_Number__c = 1, Short_Name__c = 'FL', Total_Square_Feet__c = 4);
        insert Floor;

        // Insert a test Data Hall
        DC_Data_Hall__c DataHall = new DC_Data_Hall__c(Name = 'Test Data Hall', DC_Floor__c = Floor.Id, Short_Name__c = 'test');
        insert DataHall;
        
        DC_Meet_Me_Room__c MeetMeRoom = new DC_Meet_Me_Room__c(Name = 'Room 101', Data_Hall__c = DataHall.Id, Short_Name__c = 'MMR');
        insert MeetMeRoom;
        
        DC_Rack__c Rack = new DC_Rack__c(Name = 'Rack 1', Meet_Me_Room__c = MeetMeRoom.Id, MRI_Suite_ID__c = '435', Number_of_Rack_Units__c =2, Row_Number__c = 2, Short_Name__c = 'RK');
        insert Rack;

        // Create a new DC_POE__c record
        DC_POE__c poe = new DC_POE__c(Name = 'POE ', Floor__c = Floor.Id);
        insert poe;
    }
    
    @IsTest
    private static void testGetDataHallsByBuilding() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
        
        DX_DCIM_ActionHelper.FlowInputs objFlowInputs = new  DX_DCIM_ActionHelper.FlowInputs();
        objFlowInputs.methodName = 'getDataHallsByBuilding';
		objFlowInputs.buildingId = building.Id;
		objFlowInputs.accountId = account.Id;
        List<DX_DCIM_ActionHelper.FlowInputs> lstFlowInputs = new List<DX_DCIM_ActionHelper.FlowInputs>();
        lstFlowInputs.add(objFlowInputs);
        System.assertNotEquals(null, DX_DCIM_ActionHelper.execute(lstFlowInputs));

        Test.stopTest();
    }
    
	@IsTest
    private static void testGetPOEAllocationsByBuilding() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        DX_DCIM_ActionHelper.FlowInputs objFlowInputs = new  DX_DCIM_ActionHelper.FlowInputs();
        objFlowInputs.methodName = 'getPOEAllocationsByBuilding';
		objFlowInputs.buildingId = building.Id;
		objFlowInputs.accountId = account.Id;
        List<DX_DCIM_ActionHelper.FlowInputs> lstFlowInputs = new List<DX_DCIM_ActionHelper.FlowInputs>();
        lstFlowInputs.add(objFlowInputs);
        System.assertNotEquals(null, DX_DCIM_ActionHelper.execute(lstFlowInputs));

        Test.stopTest();
    }
	
    @IsTest
    private static void testGetTenantSuitesByBuilding() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        DX_DCIM_ActionHelper.FlowInputs objFlowInputs = new  DX_DCIM_ActionHelper.FlowInputs();
        objFlowInputs.methodName = 'getTenantSuitesByBuilding';
		objFlowInputs.buildingId = building.Id;
		objFlowInputs.accountId = account.Id;
        List<DX_DCIM_ActionHelper.FlowInputs> lstFlowInputs = new List<DX_DCIM_ActionHelper.FlowInputs>();
        lstFlowInputs.add(objFlowInputs);
        System.assertNotEquals(null, DX_DCIM_ActionHelper.execute(lstFlowInputs));

        Test.stopTest();
    }
    
    @IsTest
    private static void testGetCabinetsByBuildingAndAccount() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        DX_DCIM_ActionHelper.FlowInputs objFlowInputs = new  DX_DCIM_ActionHelper.FlowInputs();
        objFlowInputs.methodName = 'getCabinetsByBuildingAndAccount';
		objFlowInputs.buildingId = building.Id;
		objFlowInputs.accountId = account.Id;
        List<DX_DCIM_ActionHelper.FlowInputs> lstFlowInputs = new List<DX_DCIM_ActionHelper.FlowInputs>();
        lstFlowInputs.add(objFlowInputs);
        System.assertNotEquals(null, DX_DCIM_ActionHelper.execute(lstFlowInputs));

        Test.stopTest();
    }
    
    @IsTest
    private static void testGetFloorsByBuilding() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        DX_DCIM_ActionHelper.FlowInputs objFlowInputs = new  DX_DCIM_ActionHelper.FlowInputs();
        objFlowInputs.methodName = 'getFloorsByBuilding';
		objFlowInputs.buildingId = building.Id;
		objFlowInputs.accountId = account.Id;
        List<DX_DCIM_ActionHelper.FlowInputs> lstFlowInputs = new List<DX_DCIM_ActionHelper.FlowInputs>();
        lstFlowInputs.add(objFlowInputs);
        System.assertNotEquals(null, DX_DCIM_ActionHelper.execute(lstFlowInputs));

        Test.stopTest();
    }
}