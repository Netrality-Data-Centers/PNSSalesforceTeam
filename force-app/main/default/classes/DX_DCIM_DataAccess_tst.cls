/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 01-13-2025
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
@IsTest
public with sharing class DX_DCIM_DataAccess_tst {
    @testSetup
    static void setup() {

        Account Account = new Account(Name = 'Test Account');
        insert Account;

        // Create a new Product record
        Product2 product = new Product2(Name = 'Test Product', ProductCode = 'TP01', Description = 'Test Product Description', IsActive = true, Product_Group__c = 'ExampleProductGroup', Product_Category__c = 'Power');
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
         DC_Data_Hall__c dataHall = new DC_Data_Hall__c(Name = 'Test Data Hall', DC_Floor__c = Floor.Id, Short_Name__c = 'test');
         insert dataHall;
         
         // Insert a test Cage
         DC_Cage__c cage = new DC_Cage__c(Name = 'Test Cage', Data_Hall__c = dataHall.Id, Type__c = 'Pod', MRI_Suite_ID__c = '34', Short_Name__c = 'CE');
         insert cage;
         
         // Insert a test Cabinet
         DC_Cabinet__c cabinet = new DC_Cabinet__c(Name = 'Test Cabinet', Cage__c =  cage.Id, Status__c = 'Occupied', Cabinet_Equivalent__c = 2, Depth_in__c = 2, Height_RU__c = 1, MRI_Suite_ID__c = '245', Short_Name__c = 'CT', Width_in__c = 3, Asset__c = asset.Id);
         insert cabinet;

        // Create a new DC_POE__c record
        DC_POE__c poe = new DC_POE__c(Name = 'POE ', Floor__c = Floor.Id);
        insert poe;

        // Create a test Power of End (PoE) Allocation record associated with the test Building
        DC_POE_Allocation__c PoeAllocation = new DC_POE_Allocation__c(Name = 'Test PoE Allocation', Floor__c = Floor.Id, POE__c = poe.Id);
        insert PoeAllocation;
        
        // Create a test Tenant Suite record associated with the test Building
        DC_Tenant_Suite__c TenantSuite = new DC_Tenant_Suite__c(Name = 'Test Tenant Suite', Floor__c = Floor.Id, Status__c = 'Occupied', Suite_Use__c = 'Powered Shell', Account__c = Account.Id, Square_Footage__c = 2);
        insert TenantSuite;

        DC_Meet_Me_Room__c MeetMeRoom = new DC_Meet_Me_Room__c(Name = 'Room 101', Data_Hall__c = dataHall.Id, Short_Name__c = 'MMR');
        insert MeetMeRoom;
        
        DC_Rack__c Rack = new DC_Rack__c(Name = 'Rack 1', Meet_Me_Room__c = MeetMeRoom.Id, MRI_Suite_ID__c = '435', Number_of_Rack_Units__c =2, Row_Number__c = 2, Short_Name__c = 'RK');
        insert Rack;
        
        DC_Panel__c Panel = new DC_Panel__c(Rack__c = Rack.Id, Mod_Model__c = 'Yes', Height_RU__c = 2, MRI_Suite_ID__c = '435', Short_Name__c = 'Pl', Starting_Position_RU__c = 1, Asset__c = asset.Id);
		insert Panel;
        
        DC_Port__c Port = new DC_Port__c(Name = 'Port', Panel__c = Panel.Id, Short_Name__c = 'PT');
		insert Port;
    }
    
    @IsTest
    static void testGetPoeAllocationsByBuilding() {
        // Query the test Building record created in the @testSetup method
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        // Instantiate the DX_DCIM_DataAccess class
        DX_DCIM_DataAccess dataAccess = new DX_DCIM_DataAccess();
        
        // Call the getPoeAllocationsByBuilding method with the ID of the test Building
        List<DC_POE_Allocation__c> results = dataAccess.getPoeAllocationsByBuilding(building.Id);
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
        
    }
    
    @IsTest
    static void testGetTenantSuitesByBuilding() {
        // Query the test Building record created in the @testSetup method
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        // Instantiate the DX_DCIM_DataAccess class
        DX_DCIM_DataAccess dataAccess = new DX_DCIM_DataAccess();
        
        // Call the getTenantSuitesByBuilding method with the ID of the test Building
        List<DC_Tenant_Suite__c> results = dataAccess.getTenantSuitesByBuilding(building.Id);
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
        
    }
    
    @IsTest
    static void testGetDataHallsByBuilding() {
        // Query the test Building record created in the @testSetup method
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        // Instantiate the DX_DCIM_DataAccess class
        DX_DCIM_DataAccess dataAccess = new DX_DCIM_DataAccess();
        
        // Call the getDataHallsByBuilding method with the ID of the test Building
        List<DC_Data_Hall__c> results = dataAccess.getDataHallsByBuilding(building.Id);
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
        
    }

    @IsTest
    static void testGetCabinetsByBuildingAndAccount() {
        // Query the test Building record created in the @testSetup method
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        // Instantiate the DX_DCIM_DataAccess class
        DX_DCIM_DataAccess dataAccess = new DX_DCIM_DataAccess();
        
        // Call the getDataHallsByBuilding method with the ID of the test Building
        List<DC_Cabinet__c> results = dataAccess.getCabinetsByBuildingAndAccount(building.Id, account.Id);
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
        
    }

    @IsTest
    static void testGetFloor() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        List<DC_Floor__c> results = DX_DCIM_DataAccess.getFloors(building.Id);
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
    }

    @IsTest
    static void testGetDataHall() {
        DC_Floor__c Floor = [SELECT Id FROM DC_Floor__c LIMIT 1];
        
        Test.startTest();
        List<DC_Data_Hall__c> results = DX_DCIM_DataAccess.getDataHalls(Floor.Id);
        Test.stopTest();
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
    }

    @IsTest
    static void testGetMeetMeRooms() {
        DC_Data_Hall__c dataHall = [SELECT Id FROM DC_Data_Hall__c LIMIT 1];
        
        Test.startTest();
        List<DC_Meet_Me_Room__c> results = DX_DCIM_DataAccess.getMeetMeRooms(dataHall.Id);
        Test.stopTest();
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
    }
    
    @IsTest
    static void testGetRacks() {
        DC_Meet_Me_Room__c MeetMeRoom = [SELECT Id FROM DC_Meet_Me_Room__c LIMIT 1];
        
        Test.startTest();
        List<DC_Rack__c> results = DX_DCIM_DataAccess.getRacks(MeetMeRoom.Id);
        Test.stopTest();
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
    }
    
    @IsTest
    static void testGetCages() {
        DC_Data_Hall__c dataHall = [SELECT Id FROM DC_Data_Hall__c LIMIT 1];
        
        Test.startTest();
        List<DC_Cage__c> results = DX_DCIM_DataAccess.getCages(dataHall.Id);
        Test.stopTest();
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
    }
    
    @IsTest
    static void testCabinets() {
        DC_Cage__c cage = [SELECT Id FROM DC_Cage__c LIMIT 1];
        
        Test.startTest();
        List<DC_Cabinet__c> results = DX_DCIM_DataAccess.getCabinets(cage.Id);
        Test.stopTest();
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
    }
    
    @IsTest
    static void testPOES() {
        DC_Floor__c Floor = [SELECT Id FROM DC_Floor__c LIMIT 1];
        
        Test.startTest();
        List<DC_POE__c> results = DX_DCIM_DataAccess.getPOES(Floor.Id);
        Test.stopTest();
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertEquals(1, results.size(), 'Expected one record to be returned');
    }

    @IsTest
    static void testObjWrapperResult() {
        Test.startTest();
        DX_DCIM_DataAccess.wrapperResult results = DX_DCIM_DataAccess.objWrapperResult('test Id', 'Test Name');
        Test.stopTest();
        
        // Assert that the method returns the expected number of records (in this case, 1)
        System.assertNotEquals(null, results, 'Expected object wrapper record to be returned');
    }
    
	@IsTest
    static void testMeetMeRoom() {
        // Query the test Building record created in the @testSetup method
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        DC_Meet_Me_Room__c MeetMeRoom = [SELECT Id FROM DC_Meet_Me_Room__c LIMIT 1];

        // Call the method being tested with the ID of the Building record
        Test.startTest();
        List<DC_Meet_Me_Room__c> result = DX_DCIM_DataAccess.getMeetMeRoom(building.Id);
        Test.stopTest();

        // Assert that the method returns the expected MeetMeRoom record
        System.assertEquals(1, result.size());
        System.assertEquals(meetMeRoom.Id, result[0].Id);
    }
    
    @IsTest
    static void testPanel() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        DC_Meet_Me_Room__c MeetMeRoom = [SELECT Id FROM DC_Meet_Me_Room__c LIMIT 1];
        
		DC_Panel__c Panel = [SELECT Id FROM DC_Panel__c LIMIT 1];
        
        // Call the method being tested with the ID of the Account and Meet Me Room record
        Test.startTest();
        List<DC_Panel__c> result = DX_DCIM_DataAccess.getPanel(account.Id, MeetMeRoom.Id);
        Test.stopTest();
        
        // Assert that the method returns the expected Panel record
        System.assertEquals(1, result.size());
        System.assertEquals(Panel.Id, result[0].Id);
    }
    
    @IsTest
    static void testPorts() {
		DC_Panel__c Panel = [SELECT Id FROM DC_Panel__c LIMIT 1];
        
        DC_Port__c Port = [SELECT Id FROM DC_Port__c LIMIT 1];
        
        // Call the method being tested with the ID of the Account and Meet Me Room record
        Test.startTest();
        List<DC_Port__c> result = DX_DCIM_DataAccess.getPorts(Panel.Id);
        Test.stopTest();
        
        // Assert that the method returns the expected Panel record
        System.assertEquals(1, result.size());
        System.assertEquals(Port.Id, result[0].Id);
    }
}