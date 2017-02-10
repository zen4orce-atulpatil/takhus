@isTest
public with sharing class OpportunitySalesControllerTest {
    @testSetup
    //Prepare test data require for testing.
    public static void testData(){
        TestClassHelper.CreateOpportunity(10);
    }
    
    @isTest
    //Description:- this method checks retrieved opportunity records.
    public static void testGetFetchOpportunity(){
		OpportunitySalesController OSC = new OpportunitySalesController();
    	List<Opportunity> lstOpportunity = OSC.getfetchOpportunities();
		List<Opportunity> lstOpp = [select id from opportunity];
    	System.assertEquals(lstOpportunity.size(),lstOpp.size());
    } 	
    
    @isTest
    /*Description - This test method will check whether a new object for opportunity is created or not*/
    public static void testCreateOpportunity(){
    	OpportunitySalesController OSC = new OpportunitySalesController();
    	OSC.createNewOpportunity();
        System.assertEquals(true,OSC.opp!=null);
    }
    
    @isTest
    //Description:- this method checks for record which is getting updated
    public static void testEditOpportunityPositive(){
    	OpportunitySalesController OSC = new OpportunitySalesController();
		List<Opportunity> lstOpportunity = OSC.getfetchOpportunities();
        if(lstOpportunity.size() > 0){
    		OSC.oppId = lstOpportunity[0].Id;
    		OSC.editOpportunity();
        	System.assertEquals(true,OSC.viewOpportunity == false);
        	System.assertEquals(true,OSC.oppNewEdit == true);
            System.assertEquals(true,OSC.opp.Id!=null);
        }
    }
    
    @isTest
    //Description:- this method checks for record which is getting updated
    public static void testEditOpportunityNegative(){
    	OpportunitySalesController OSC = new OpportunitySalesController();
        OSC.oppId = null;
    	OSC.editOpportunity();
        System.assertEquals(true,OSC.viewOpportunity == false);
        System.assertEquals(true,OSC.oppNewEdit == true);
        System.assertEquals(true,OSC.opp.Id == null);
    }
    
    @isTest
    //Description:- this method checks for view Opportunity setup
    public static void testViewOpportunityDataPositive(){
        OpportunitySalesController OSC = new OpportunitySalesController();
    	List<Opportunity> lstOpportunity = OSC.getfetchOpportunities();
        if(lstOpportunity.size() > 0){
    		OSC.oppId = lstOpportunity[0].Id;
    		OSC.viewOpportunityData();
        	System.assertEquals(true, OSC.viewOpportunity == true);
        	System.assertEquals(true, OSC.oppNewEdit == false);
        	System.assertEquals(true, OSC.opp.Id!=null);
        }
    }
    
    @isTest
    //Description:- this method checks for view Opportunity setup
    public static void testViewOpportunityDataNegative(){
        OpportunitySalesController OSC = new OpportunitySalesController();
    	OSC.oppId = null;
    	OSC.viewOpportunityData();
        System.assertEquals(true, OSC.viewOpportunity == true);
        System.assertEquals(true, OSC.oppNewEdit == false);
        System.assertEquals(true, OSC.opp.Id == null);
    }
    
    @isTest
    //Description:- this method checks wheather Opportunity is deleted or not.
    public static void testDeleteOpportunityPositive(){
        OpportunitySalesController OSC = new OpportunitySalesController();
    	List<Opportunity> lstOpportunity = OSC.getfetchOpportunities();
    	OSC.oppId = lstOpportunity[0].Id;
    	OSC.deleteOpportunity();
       	System.assertEquals('success',OSC.notificationType);
        System.assertEquals(Label.DeleteMessage,OSC.notificationMessage);
    }
    
    @isTest
    //Description:- this method checks wheather Opportunity is deleted or not.
    public static void testDeleteOpportunityNegative(){
        OpportunitySalesController OSC = new OpportunitySalesController();
    	List<Opportunity> lstOpportunity = OSC.getfetchOpportunities();
    	OSC.oppId = lstOpportunity[0].Id;
        delete lstOpportunity[0];
    	OSC.deleteOpportunity();
        System.assertEquals(Label.FailureMessage,OSC.notificationMessage);
    }
	
    @isTest
    //Description:- this method checks for closeAllPanel setup
    public static void testCloseAllPanel(){
        OpportunitySalesController OSC = new OpportunitySalesController();
    	OSC.closeAllPanel();
    }
}