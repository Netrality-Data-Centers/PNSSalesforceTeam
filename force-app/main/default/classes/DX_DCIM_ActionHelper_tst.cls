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

        // Create a new Product record
        Product2 product = new Product2(Name = 'Test Product', ProductCode = 'TP01', Description = 'Test Product Description', IsActive = true, Product_Group__c = 'ExampleProductGroup', Product_Category__c = 'Power', DC_Allocation_Required__c = 'Yes', DC_Asset_Type__c = 'Fiber Pair', DC_Income_Category__c = 'test', DC_Number_of_Assets__c = '1');
        // Insert the Product record
        insert product;

        // Create a new PricebookEntry record
        PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = product.Id, UnitPrice = 100, IsActive = true);
        // Insert the PricebookEntry record
        insert pricebookEntry;
        
        // Create a new Pricebook2 record
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // Create a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = product.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Opportunity Opportunity = new Opportunity(Name = 'Nombre de la oportunidad de prueba', StageName = 'Qualifying', CloseDate = Date.today().addDays(30), Amount = 10000, Probability = 50, LeadSource = 'Web', Type = 'New Logo', AccountId = Account.Id); 
        // Insert the Opportunity record
        insert Opportunity;

        // Create a new Order record
        Quote Service_order = new Quote(Name = 'Test Order', Status = 'Draft', Pricebook2Id = customPB.Id, OpportunityId = Opportunity.Id, Commencement_Date__c = Date.today(), Term__c = 'test');
        // Insert the Order record
        insert Service_order;

        // Create a new OrderItem record
        QuoteLineItem ServiceOrderLineItem = new QuoteLineItem(QuoteId = Service_order.Id, PricebookEntryId = customPrice.Id, Quantity = 1, UnitPrice = pricebookEntry.UnitPrice);
        // Insert the Service Order Line Item record
        insert ServiceOrderLineItem;

        // Create a new Asset record
        Asset asset = new Asset(Name = 'Test Asset', AccountId = Account.Id, SerialNumber = '123456', InstallDate = Date.today(), UsageEndDate = Date.today().addYears(1), Status = 'Purchased', Service_Order_Line_Item__c = ServiceOrderLineItem.Id, Opportunity__c = Opportunity.Id);
        // Insert the Asset record
        insert asset;

        // Create a new Building__c record
        Building__c building = new Building__c(Name = 'Test Building');
        insert building;

        // Create a new DC_Floor__c record
        DC_Floor__c Floor = new DC_Floor__c(Name = 'Test Floor', Building__c = building.Id , Floor_Number__c = 1, Short_Name__c = 'FL', Total_Square_Feet__c = 4);
        insert Floor;

        // Insert a test Data Hall
        DC_Data_Hall__c DataHall = new DC_Data_Hall__c(Name = 'Test Data Hall', DC_Floor__c = Floor.Id, Short_Name__c = 'test');
        insert DataHall;

        // Insert a test Cage
        DC_Cage__c cage = new DC_Cage__c(Name = 'Test Cage', Data_Hall__c = dataHall.Id, Type__c = 'Pod', MRI_Suite_ID__c = '34', Short_Name__c = 'CE');
        insert cage;
        
        // Insert a test Cabinet
        DC_Cabinet__c cabinet = new DC_Cabinet__c(Name = 'Test Cabinet', Cage__c =  cage.Id, Status__c = 'Occupied', Cabinet_Equivalent__c = 2, Depth_in__c = 2, Height_RU__c = 1, MRI_Suite_ID__c = '245', Short_Name__c = 'CT', Width_in__c = 3, Asset__c = asset.Id, Account_Lookup__c =Account.Id);
        insert cabinet;
        
        DC_Meet_Me_Room__c MeetMeRoom = new DC_Meet_Me_Room__c(Name = 'Room 101', Data_Hall__c = DataHall.Id, Short_Name__c = 'MMR');
        insert MeetMeRoom;
        
        DC_Rack__c Rack = new DC_Rack__c(Name = 'Rack 1', Meet_Me_Room__c = MeetMeRoom.Id, MRI_Suite_ID__c = '435', Number_of_Rack_Units__c =2, Row_Number__c = 2, Short_Name__c = 'RK');
        insert Rack;

        // Create a new DC_POE__c record
        DC_POE__c poe = new DC_POE__c(Name = 'POE ', Floor__c = Floor.Id);
        insert poe;

        // Create a test Power of End (PoE) Allocation record associated with the test Building
        DC_POE_Allocation__c PoeAllocation = new DC_POE_Allocation__c(Name = 'Test PoE Allocation', Floor__c = Floor.Id, POE__c = poe.Id);
        insert PoeAllocation;

        // Create a test Tenant Suite record associated with the test Building
        DC_Tenant_Suite__c TenantSuite = new DC_Tenant_Suite__c(Name = 'Test Tenant Suite', Floor__c = Floor.Id, Status__c = 'Occupied', Suite_Use__c = 'Powered Shell', Account__c = Account.Id, Square_Footage__c = 2, Short_Name__c = 'TT');
        insert TenantSuite;

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