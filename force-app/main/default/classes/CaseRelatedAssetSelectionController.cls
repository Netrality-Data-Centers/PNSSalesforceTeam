public with sharing class CaseRelatedAssetSelectionController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRelatedAssets(Id caseId) {
        // Get Case and related Quote
        Case currentCase = [
            SELECT Id, DX_Service_Order__c, Subject FROM Case WHERE Id = :caseId
        ];
        System.debug('got case:' + currentCase);
        // Get Assets related to the Quote
        List<Asset> assets = new List<Asset>();
        if (currentCase.DX_Service_Order__c != null) {
            System.debug('currentCase.DX_Related_Service_Order__c != null');
            
            assets = [
                SELECT Id, Name, SerialNumber, Status, Product2.Name, Asset_Location__c, Asset_Type__c 
                FROM Asset 
                WHERE Service_Order__c = :currentCase.DX_Service_Order__c
            ];
            System.debug('got Assets, the length was:' + assets.size() );
        } else{
            System.debug('currentCase.DX_Service_Order__c == null');
        }
        
        return new Map<String, Object>{
            'assets' => assets,
            'caseName' => currentCase.Subject
        };
    }
    
    @AuraEnabled
    public static RDraw.CanvasScene getCanvasSceneForRackRow(String rackRowId,  Integer desiredUSize) {
        if (desiredUSize == null) {
            desiredUSize = 1;
        }
        
        List<DC_Rack__c> racks = [SELECT Id, Name, Number_of_Rack_Units__c, Rack_Type__c, Asset__c, Row_Number__c, Rack_Row__c, Account__c, Meet_Me_Room__c FROM DC_Rack__c WHERE Rack_Row__c = :rackRowId];
        RDraw__Interaction_Definition__c templateInteractionDefinition = getRackRowTemplateInteractionDefinition();
        RDraw.CanvasScene canvasScene = RDraw.CanvasScene.fromJSON(templateInteractionDefinition.RDraw__Settings__c, false);
        
        for (DC_Rack__c rack : racks) {
            RDraw.DroppableAreaTemplate droppableAreaTemplate = getDroppableAreaTemplateForRackSize(canvasScene, rack.Number_of_Rack_Units__c);
            RDraw.DroppableArea droppableArea = getFreshDroppableArea(droppableAreaTemplate.id);
            List<DC_Panel__c> rackPanels = [SELECT Id, Name, Rack__c, Asset__c, Height_RU__c, Starting_Position_RU__c, Total_Number_of_Ports__c 
                                            FROM DC_Panel__c 
                                            WHERE Rack__c = :rack.Id 
                                            ORDER BY Starting_Position_RU__c];
            
            Integer currentPosition = 1;
            for (DC_Panel__c panel : rackPanels) {
                if (panel.Starting_Position_RU__c > currentPosition) {
                    Integer emptySpaceSize = panel.Starting_Position_RU__c.intValue() - currentPosition;
                    // Fill empty space with the desired size
                    while (emptySpaceSize >= desiredUSize) {
                        RDraw.DraggableItemTemplate emptyTemplate = getDraggableItemTemplateForRackSize(canvasScene, desiredUSize, true);
                        RDraw.BaseCanvasItem emptyItem = getFreshDraggableItem(emptyTemplate.id);
                        emptyItem.name = 'Empty Space';
                        emptyItem.value = String.valueOf(currentPosition); // Set the value field to the starting U position
                        droppableArea.draggableItems.add(emptyItem);
                        emptySpaceSize -= desiredUSize;
                        currentPosition += desiredUSize; // Update currentPosition as we place items
                    }
                }
                
                Integer panelHeight = panel.Height_RU__c.intValue();
                RDraw.DraggableItemTemplate draggableItemTemplate = getDraggableItemTemplateForRackSize(canvasScene, panelHeight, false);
                RDraw.BaseCanvasItem baseCanvasItem = getFreshDraggableItem(draggableItemTemplate.id);
                baseCanvasItem.name = panel.Name;
                baseCanvasItem.value = String.valueOf(panel.Starting_Position_RU__c.intValue()); // Set the value field to the panel's starting position
                droppableArea.draggableItems.add(baseCanvasItem);
                
                currentPosition = panel.Starting_Position_RU__c.intValue() + panelHeight;
            }
            
            // Check for any remaining empty space at the end of the rack
            if (currentPosition <= rack.Number_of_Rack_Units__c) {
                Integer emptySpaceSize = rack.Number_of_Rack_Units__c.intValue() - currentPosition + 1;
                // Fill remaining empty space with the desired size
                while (emptySpaceSize >= desiredUSize) {
                    RDraw.DraggableItemTemplate emptyTemplate = getDraggableItemTemplateForRackSize(canvasScene, desiredUSize, true);
                    RDraw.BaseCanvasItem emptyItem = getFreshDraggableItem(emptyTemplate.id);
                    emptyItem.name = 'Empty Space';
                    emptyItem.value = String.valueOf(currentPosition); // Set the value field to the starting U position
                    droppableArea.draggableItems.add(emptyItem);
                    emptySpaceSize -= desiredUSize;
                }
            }
            
            canvasScene.placedDroppableAreas.add(droppableArea);
        }
        
        return canvasScene;
    }
    private static String generateRandomId() {
        Datetime now = Datetime.now();
        Long timeInMillis = now.getTime();
        String template = 'xxyxxy3xxy-xy';
        String result = '';
        
        for (Integer i = 0; i < template.length(); i++) {
            String match = template.substring(i, i + 1);
            Integer r = (Math.random() * 16).intValue();
            
            if (timeInMillis > 0) {
                // Modulus operation in Apex using Math.floor
                r = (Integer)((timeInMillis + r) - (Math.floor((timeInMillis + r) / 16) * 16));
                timeInMillis = (Long)Math.floor(timeInMillis / 16);
            }
            
            if (match.toLowerCase() == 'x') {
                // Convert to hex using standard hex digits
                result += getHexDigit(r);
            } else if (match.toLowerCase() == 'y') {
                // Handle Y case with specific bit operations
                Integer yValue = (r & 3) | 8;  // Same as 0x3 and 0x8
                result += getHexDigit(yValue);
            } else {
                result += match;
            }
        }
        return result;
    }
    
    // Helper method to convert numbers to hex digits
    private static String getHexDigit(Integer num) {
        String hexChars = '0123456789abcdef';
        return hexChars.substring(Math.mod(Math.abs(num), 16), Math.mod(Math.abs(num), 16) + 1);
    }
    private static RDraw.DroppableArea getFreshDroppableArea(String templateId){
        RDraw.DroppableArea da = new RDraw.DroppableArea();
        da.templateId = templateId;
        da.id = generateRandomId();
        // da.sortingEnabled = true;
        // da.sortingDirection = 'end';
        return da;
    }
    private static RDraw.BaseCanvasItem getFreshDraggableItem(String templateId){
        RDraw.BaseCanvasItem bci = new RDraw.BaseCanvasItem();
        bci.templateId = templateId;
        bci.id = generateRandomId();
        return bci;
    }
    private static RDraw.DroppableAreaTemplate getDroppableAreaTemplateForRackSize(RDraw.CanvasScene canvasScene,Decimal rackSize){
        RDraw.DroppableAreaTemplate temp = new RDraw.DroppableAreaTemplate();
        String formattedRackSize = String.valueOf(rackSize) + 'U';
        for(RDraw.DroppableAreaTemplate template : canvasScene.droppableAreaTemplates) {
            if(template.name == formattedRackSize) {
                temp =  template;
                return temp;
            }
        }
        return temp;
    }
    private static RDraw.DraggableItemTemplate getDraggableItemTemplateForRackSize(RDraw.CanvasScene canvasScene,Integer USize,Boolean available){
        String formattedUSize = String.valueOf(USize);
        String suffix = available?'-Available':'-Occupied';
        RDraw.DraggableItemTemplate temp = new RDraw.DraggableItemTemplate();
        String formattedChassisName =  formattedUSize + suffix;
        for(RDraw.DraggableItemTemplate template : canvasScene.draggableItemTemplates) {
            if(template.name == formattedChassisName) {
                temp = template;
                return temp;
            }
        }
        return temp;
    }
    @AuraEnabled
    public static RDraw__Interaction_Definition__c getRackRowTemplateInteractionDefinition(){
        RDraw__Interaction_Definition__c templateInteractionDefinition = [SELECT Id, Name, RDraw__Type__c, RDraw__Associated_Object__c, RDraw__Associated_Record__c, RDraw__Name__c, RDraw__Settings__c FROM RDraw__Interaction_Definition__c WHERE RDraw__Type__c = '2D_Scene_Settings' AND RDraw__Associated_Object__c='DC_Rack_Row__c'  LIMIT 1];
        return templateInteractionDefinition;
        
    }
}