@isTest
public class DX_viewCrossConnectsInformation_ctrTest {
@testSetup
    static void setup() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        // Create a test user
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ContactId = testContact.Id
        );
        insert testUser;
        
        Building__c objBuilding = new Building__c();
        objBuilding.Name = 'test Building';
        insert objBuilding;
        
        DC_Floor__c objDCFloor = new DC_Floor__c();
        objDCFloor.Name = 'test DC Floor';
        objDCFloor.Short_Name__c = 'te';
        objDCFloor.Building__c = objBuilding.Id;
        objDCFloor.Floor_number__c = 2;
        objDCFloor.Total_Square_Feet__c = 2;
        insert objDCFloor;
        
		DC_Data_Hall__c objDataHall = new DC_Data_Hall__c ();
        objDataHall.Name = 'test DataHall';
        objDataHall.DC_Floor__c = objDCFloor.Id;
        objDataHall.Short_Name__c = 'test';
        insert objDataHall;
        
        DC_Meet_Me_Room__c objMeetMeRoom = new DC_Meet_Me_Room__c();
        objMeetMeRoom.Name = 'test Meet Me Room';
        objMeetMeRoom.Data_Hall__c = objDataHall.Id;
        objMeetMeRoom.Short_Name__c = 'te';
        insert objMeetMeRoom;
        
        DC_Rack__c objRack = new DC_Rack__c();
        objRack.name= 'test Rack';
        objRack.MRI_Suite_ID__c = 'IdSui';
        objRack.Meet_Me_Room__c = objMeetMeRoom.Id;
		objRack.Number_of_Rack_Units__c = 2;
        objRack.Short_Name__c = 'te';
        insert objRack;
        
        DC_Panel__c objPanel = new DC_Panel__c (); 
        objPanel.Name = 'test Panel';
        objPanel.Rack__c = objRack.Id;
		objPanel.Mod_Model__c = 'Yes'; 
		objPanel.Height_RU__c = 2;
        objPanel.MRI_Suite_ID__c = 'text';
		objPanel.Number_of_Ports_Tall__c = 2;
		objPanel.Number_of_Ports_Wide__c = 2;
        objPanel.Short_Name__c = 'Te';
        insert objPanel;
        
        DC_Port__c  objDCPort  = new DC_Port__c();
        objDCPort.Name = 'test DestinationPort';
        objDCPort.Panel__c = objPanel.Id;
        objDCPort.Short_Name__c = 'te';
        insert objDCPort;
        
        DC_Cross_Connect__c crossConnect1 = new DC_Cross_Connect__c();
        crossConnect1.Destination_Account__c = testContact.AccountId;
        crossConnect1.Origination_Account__c = testContact.AccountId;
        crossConnect1.Xconnect_date__c = Date.today();
        crossConnect1.Destination_Port__c = objDCPort.Id;
        crossConnect1.Origination_Port__c = objDCPort.Id;
        insert crossConnect1;
        
        DC_Cross_Connect__c crossConnect2 = new DC_Cross_Connect__c();
        crossConnect2.Destination_Account__c = testContact.AccountId;
		crossConnect2.Origination_Account__c = testContact.AccountId;
        crossConnect2.Xconnect_date__c = Date.today();
		crossConnect2.Destination_Port__c = objDCPort.Id;
        crossConnect2.Origination_Port__c = objDCPort.Id;
        insert crossConnect2;
    }
    
    @isTest
    static void testGetCrossConnets() {
        User testUser = [SELECT Id, ContactId FROM User WHERE Username = 'testuser@example.com'];
        System.runAs(testUser) {
            Test.startTest();
            List<DC_Cross_Connect__c> resultCrossConnects = DX_viewCrossConnectsInformation_ctr.getCrossConnets();
            System.assertequals(!resultCrossConnects.isEmpty(),false);
            Test.stopTest();
        }
    }
}