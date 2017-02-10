@isTest
public class OpportunityMarketingControllerTest {
	
    @testSetup
    //Prepare test data require for testing.
    public static void testData(){
        //TestClassHelper.CreateOpportunity(10);
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        for(Integer i=0;i<10;i++){
            Opportunity opp = new Opportunity();
    		opp.Name = 'Sample Opportunity '+i;
    		opp.Customer_Name__c = 'James Bond';
    		opp.Amount = 50000;
    		Opp.CloseDate = Date.today().addDays(30);
    		opp.Description = 'Sample Description';
            opp.StageName = 'Prospecting';
            opp.Approval_Status__c = 'Submitted';
    		lstOpportunity.add(opp);
        }
        System.debug('lstOpportunity  before insert--->'+lstOpportunity);
        //Database.SaveResult[] results =  Database.insert(lstOpportunity,false);
        List<Database.SaveResult> results = Database.insert(lstOpportunity,false);
        //for(Integer i=0;i<results.size();i++){
        for(Database.SaveResult SR:results){
            System.debug('results[i].isSuccess---->'+SR);
        }
        
    }
    
    @isTest
    public static void testGetFetchOpportunity(){
    	OppMarketingController OMC = new OppMarketingController();
        List<Opportunity> lstOpportunity = OMC.getfetchOpportunities();
        Integer oppCount = [select count() from Opportunity];
        System.assertEquals(oppCount,lstOpportunity.size());
    }
    
    @isTest
    public static void testViewOpportunityWithValue(){
		OppMarketingController OMC = new OppMarketingController();
        List<Opportunity> lstOpportunity = OMC.getfetchOpportunities();
        OMC.selectedOppId = String.valueOf(lstOpportunity[0].Id);
        OMC.userAction = 'ViewOpp';
        OMC.viewOppportunity();
        System.assertEquals(true,OMC.opp!=null);
        System.assertEquals(true,OMC.rendereViewOppPanel);
        System.assertEquals(false,OMC.renderSelectProject);
        System.assertEquals(false,OMC.renderCreateProjectPanel);
    }
    
    @isTest
    public static void testViewOpportunityWithoutValue(){
    	OppMarketingController OMC = new OppMarketingController();
        OMC.selectedOppId = null;
        OMC.viewOppportunity();
        System.assertEquals(true,OMC.opp!=null);
        System.assertEquals(false,OMC.rendereViewOppPanel);
        System.assertEquals(true,OMC.renderSelectProject);
        System.assertEquals(false,OMC.renderCreateProjectPanel);
    }
    
    @isTest
    public static void testViewCreateProjectPanelWithValue(){
    	OppMarketingController OMC = new OppMarketingController();
        OMC.selectedProjectType='NPI';
        OMC.viewCreateProjectPanel();
        System.assertEquals(true,OMC.renderCreateProjectPanel);
        System.assertEquals(false,OMC.rendereViewOppPanel);
    }
    
    @isTest
    public static void testViewCreateProjectPanelWithoutValue(){
    	OppMarketingController OMC = new OppMarketingController();
        OMC.viewCreateProjectPanel();
        System.assertEquals(false,OMC.renderCreateProjectPanel);
        System.assertEquals(false,OMC.rendereViewOppPanel);
    }
    
    @isTest
    public static void testUpdateComment(){
        OppMarketingController OMC = new OppMarketingController();
    	List<Opportunity> lstOpportunity = OMC.getfetchOpportunities();
        System.debug('lstOpportunity--->'+lstOpportunity);
        OMC.opp = lstOpportunity[0];
        OMC.buttonAction = 'approve';
        OMC.oppAction = 'savecreate';
        OMC.udateComments();
    }
    
    @isTest
    public static void testUpdateCommentWithoutValue(){
        OppMarketingController OMC = new OppMarketingController();
    	List<Opportunity> lstOpportunity = OMC.getfetchOpportunities();
        System.debug('lstOpportunity--->'+lstOpportunity);
        OMC.opp = lstOpportunity[0];
        OMC.udateComments();
    }
}