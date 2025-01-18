/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 01-13-2025
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
public with sharing class DX_PanelSelectorMeetMeRoomPanel_ctr {
    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getMeetMeRoom(String buildingId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Meet_Me_Room__c> lstMeetMeRooms = DX_DCIM_DataAccess.getMeetMeRoom(buildingId);
        if(!lstMeetMeRooms.isEmpty()){
            for(DC_Meet_Me_Room__c item : lstMeetMeRooms){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        
        return lstwrapperResult;
    }

    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getPanel(String accountId, String meetMeRoomId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Panel__c> lstPanels = DX_DCIM_DataAccess.getPanel(meetMeRoomId, accountId);
        if(!lstPanels.isEmpty()){
            for(DC_Panel__c item : lstPanels){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        
        return lstwrapperResult;
    }
}