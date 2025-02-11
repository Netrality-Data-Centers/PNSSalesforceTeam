/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 12-18-2024
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
@IsTest
public with sharing class DX_PanelSelectorRacks_tst {
    @testSetup
    static void setup() {

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
    }

    @IsTest
    static void testGetFloor() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorRacks_ctr.getFloors(building.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }

    @IsTest
    static void testGetDataHall() {
        DC_Floor__c Floor = [SELECT Id FROM DC_Floor__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorRacks_ctr.getDataHalls(Floor.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }
    
    @IsTest
    static void testGetMeetMeRooms() {
        DC_Data_Hall__c DataHall = [SELECT Id FROM DC_Data_Hall__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorRacks_ctr.getMeetMeRooms(DataHall.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }

    @IsTest
    static void testGetRacks() {
        DC_Meet_Me_Room__c MeetMeRoom = [SELECT Id FROM DC_Meet_Me_Room__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorRacks_ctr.getRacks(MeetMeRoom.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }
    
}