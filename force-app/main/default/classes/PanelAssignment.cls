public with sharing class PanelAssignment {
    public PanelAssignment() {
        StartingPosition = 0;
        Size = 0;
        RackId = '';
    }
    @AuraEnabled
    @InvocableVariable
    public Integer StartingPosition;
    
    @AuraEnabled
    @InvocableVariable
    public Integer Size;
    
    @AuraEnabled
    @InvocableVariable
    public String RackId;
    
    @AuraEnabled
    @InvocableVariable
    public String Asset;
    
    @AuraEnabled
    public static List<PanelAssignment> generatePanelAssignments(List<Integer> sizes) {
        List<PanelAssignment> panelAssignments = new List<PanelAssignment>();
        
        for (Integer size : sizes) {
            PanelAssignment panelAssignment = new PanelAssignment();
            panelAssignment.Size = size;
            panelAssignments.add(panelAssignment);
        }
        
        return panelAssignments;
    }
}