@isTest
public class CreateEditOpportunityControllerTest {
    
    @testSetup
    //Description:- Prepares test data required for testing
    public static void testData(){
        TestClassHelper.CreateAccount(10);
    }
    
    @isTest
    //Description:- this methid checks for New Opportunity.
    public static void testGetOppForNew(){
        CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
        Opportunity opp = CEOC.getOpp();
        System.assertEquals(true, opp.Id == null);
    }
    
    @isTest
    //Description:- this methid checks for edit opportunity.
    public static void testGetOppForEdit(){
        CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
        List<Opportunity> lstopp = TestClassHelper.CreateOpportunity(1);
        CEOC.oppRec = lstopp[0];
        Opportunity oppRecord = CEOC.getOpp();
        System.assertEquals(true,oppRecord.Id!=null);
    }
    
	@isTest
    //Description:- this methid checks retried account records.
    public static void testgetAccounts(){
        CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
        List<SelectOption> lstAccount = CEOC.getAccounts();
        List<Account> lstAcc = [select id from Account];
        System.assertEquals(lstAcc.size(),lstAccount.size());
    }    
    
    /*@isTest
    //Description:- this method checks retrived .
    public static void testGetUserByDept(){
		CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
        List<SelectOption> lstUsers = CEOC.getUsersByDept();
        System.assertEquals(true,lstUsers.size()>0);
    }*/
    
    @isTest
    //Description:- this methid checks wether opprtunity getting save or not.
    public static void testSaveOpportunity(){
        CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
        Opportunity opp = new Opportunity();
        opp.Name = 'Sample Opportunity';
        opp.Customer_Name__c = 'James Bond';
        opp.Amount = 50000;
        Opp.AccountId = '001000000000000';
        Opp.CloseDate = Date.today().addDays(30);
        opp.Description = 'Sample Description';
        opp.StageName = 'Prospecting';    
        CEOC.oppRec = opp;
		Opportunity oppRecord = CEOC.getOpp();
        CEOC.saveOpportunity();
        System.assertEquals(Label.SaveMessage, CEOC.notificationMessage);
    }
    
    @isTest
    //Description:- this methid checks wether opprtunity getting save or not.
    public static void testSaveBlankOpportunity(){
        CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
        Opportunity opp = new Opportunity();
        Opp.CloseDate = Date.today().addDays(30);
        opp.StageName = 'Prospecting';    
        CEOC.oppRec = opp;
		Opportunity oppRecord = CEOC.getOpp();
        CEOC.saveOpportunity();
        System.assertEquals(Label.FailureMessage, CEOC.notificationMessage);
    }
    
    @isTest
    //Description:- this methid checks wether opprtunity getting updated or not.
    public static void testUpdateOpportunity(){
        CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
		List<Opportunity> lstopp = TestClassHelper.CreateOpportunity(1);
        CEOC.oppRec = lstopp[0];
        Opportunity oppRecord = CEOC.getOpp();
        CEOC.saveOpportunity();
        System.assertEquals(Label.UpdateMessage, CEOC.notificationMessage);
    }
    
    @isTest
    //Description:- this methid checks wether opprtunity getting submitted for approval or not.
    public static void testSubmitExistingFrApproval(){
    	CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
		List<Opportunity> lstopp = TestClassHelper.CreateOpportunity(1);
        CEOC.oppRec = lstopp[0];
        Opportunity oppRecord = CEOC.getOpp();
        CEOC.submitForApproval();
        System.assertEquals(Label.SubmitMessage, CEOC.notificationMessage);
    }
    
    @isTest
    //Description:- this methid checks wether opprtunity getting submitted for approval or not.
    public static void testSubmitNewOppFrApproval(){
    	CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
		Opportunity opp = CEOC.getOpp();
        opp.Name = 'Sample Opportunity';
        opp.Customer_Name__c = 'James Bond';
        opp.Amount = 50000;
        Opp.CloseDate = Date.today().addDays(30);
        opp.Description = 'Sample Description';
        opp.StageName = 'Prospecting';
        CEOC.oppRec = opp;
        Opportunity oppRecord = CEOC.getOpp();
        CEOC.submitForApproval();
        System.assertEquals(Label.SubmitMessage, CEOC.notificationMessage);
    }
    
    @isTest
    //Description:- this methid checks wether opprtunity getting submitted for approval or not.
    public static void testSubmitFrApproval(){
    	CreateEditOpportunityController CEOC  = new CreateEditOpportunityController();
		Opportunity opp = CEOC.getOpp();
        Opp.CloseDate = Date.today().addDays(30);
        opp.StageName = 'Prospecting';
        CEOC.oppRec = opp;
        Opportunity oppRecord = CEOC.getOpp();
        CEOC.submitForApproval();
        System.assertEquals(Label.FailureMessage, CEOC.notificationMessage);
    }
}