@IsTest
public class PanelAssignmentTest {
    
    @IsTest
    static void testPanelAssignmentConstructor() {
        // Act
        PanelAssignment panelAssignment = new PanelAssignment();
        
        // Assert
        System.assertEquals(0, panelAssignment.StartingPosition, 'StartingPosition should be initialized to 0');
        System.assertEquals(0, panelAssignment.Size, 'Size should be initialized to 0');
        System.assertEquals('', panelAssignment.RackId, 'RackId should be initialized to empty string');
        System.assertEquals(null, panelAssignment.Asset, 'Asset should be initialized to null');
    }
    
    @IsTest
    static void testPanelAssignmentProperties() {
        // Arrange
        PanelAssignment panelAssignment = new PanelAssignment();
        
        // Act
        panelAssignment.StartingPosition = 5;
        panelAssignment.Size = 10;
        panelAssignment.RackId = 'RACK-001';
        panelAssignment.Asset = 'ASSET-001';
        
        // Assert
        System.assertEquals(5, panelAssignment.StartingPosition, 'StartingPosition should be 5');
        System.assertEquals(10, panelAssignment.Size, 'Size should be 10');
        System.assertEquals('RACK-001', panelAssignment.RackId, 'RackId should be RACK-001');
        System.assertEquals('ASSET-001', panelAssignment.Asset, 'Asset should be ASSET-001');
    }
}