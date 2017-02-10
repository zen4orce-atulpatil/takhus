@isTest
public class CreateProjectControllerTest {
	
    @testSetup
    public static void testData(){
        Applications__c app = new Applications__c();
        app.Name='Drying agent';
        Insert app;
        
        List<Opportunity> lstOpportunity = TestClassHelper.CreateOpportunity(1);
        /*Applications__c app2 = new Applications__c();
        app2.Name='Heat Treatment';
        Applications__c app3 = new Applications__c();
        app3.Name='Adhesive';*/
        
        Chem_Regulation__c chemReg = new Chem_Regulation__c();
        chemReg.Name = 'NSF 60';
        Insert chemReg;
        
        Pkg_Size__c pkgSize = new Pkg_Size__c();
        pkgSize.Name = 'Drum';
        Insert pkgSize;
        
		Product__c product = new Product__c();
		product.Name = 'Sample Product';
        product.Tradename__c = 'Some Trade';
        product.Project_Type__c = 'NPI';
        Insert product;
        
        Product__c myProduct = new Product__c();
		product.Name = 'Sample';
        product.Tradename__c = 'Some Trade';
        product.Project_Type__c = 'NPI';
        Insert myProduct;
        
		Project__c project = new Project__c();
		project.Status__c = 'Active';
        project.Approval_Status__c = 'Not Submitted';
        project.Department__c = 'Marketing';	
        project.Product__c = product.Id;
        Insert project;
        
        PM_Application__c pmApplication  = new PM_Application__c();
        PMApplication.Project__c = product.Id;
        PMApplication.Applications__c = app.Id;
        insert PMApplication;
        
        Product_Pkg__c productPkg = new Product_Pkg__c();
        productPkg.Pkg_Size__c = pkgsize.Id;
        productPkg.Product__c = product.Id;
        productPkg.Projects_and_Approval__c = project.Id;
        insert productPkg;
        
        PM_Regulatory_Clearance__c varPMregClearance = new PM_Regulatory_Clearance__c();
        varPMregClearance.Project__c = product.Id;
        varPMregClearance.Reg_Clearance__c = 'No';
        varPMregClearance.Regulatory_List__c = chemReg.Id;
        Insert varPMregClearance;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'tstUser', Email='mustafa.jhabuawala1@zen4orce.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,Department = 'Rnd', 
            TimeZoneSidKey='America/Los_Angeles', UserName='jhabuawala.mustafa1@zen4orce.com');
        Insert u;
        
    }
    
    @isTest
    public static void testGetProductWithoutValue(){
        CreateProjectController CPC = new CreateProjectController();
        CreateProjectController.reset = true;
    	Product__c product  = CPC.getProduct();
        System.assertEquals(true,product!=null);
        System.assertEquals(true,product.Id == null);
    }
    
    @isTest
	public static void testGetProductWithvalue(){
        CreateProjectController CPC = new CreateProjectController();
        Product__c varProduct = [select Id, Name, Tradename__c, Product_Description__c from Product__c where Name=:'Sample Product'];
        Project__c project = [SELECT Project__c.Product__r.id,
                              Project__c.Product__r.Tradename__c,
                              Project__c.Product__r.Name,Approval_Status__c,
                              CreatedById,
                              CreatedDate,Department__c,
                              Id,
                              LastModifiedDate,
                              Name,
                              Product__c,
                              Project_Description__c,
                              Project_Type__c,
                              Status__c FROM Project__c];
        CPC.projectRecord = project;
        //CPC.setProduct(varProduct);
    	Product__c product  = CPC.getProduct();
        System.assertEquals(true,product!=null);
        System.assertEquals(true,product.Id != null);
    }
    
    @isTest
    public static void testGetApplication(){
        CreateProjectController CPC = new CreateProjectController();
        List<SelectOption> laApplication = CPC.getApplication();
        Integer appCount = [select count() from Applications__c];
        appCount=appCount+1;//This count added for counting default value.
        System.assertEquals(appCount,laApplication.size());
    }
    
    @isTest
    public static void testGetSelectedValueWithValue(){
        CreateProjectController CPC = new CreateProjectController();
        Product__c varProduct = [select Id, Name, Tradename__c, Product_Description__c from Product__c where Name=:'Sample Product'];
        CPC.setProduct(varProduct);
        String selectedValue = CPC.getSelectedValue();
        List<SelectOption> lstApplication = CPC.getApplication();
        System.assertEquals(lstApplication[1].getValue(),selectedValue);
    }
    
    @isTest
    public static void testGetSelectedValueWithoutValue(){
        CreateProjectController CPC = new CreateProjectController();
        Product__c varProduct = [select Id, Name, Tradename__c, Product_Description__c from Product__c where Name!=:'Sample Product'];
        CPC.setProduct(varProduct);
        String selectedValue = CPC.getSelectedValue();
        List<SelectOption> laApplication = CPC.getApplication();
        System.assertEquals('Select',selectedValue);
    }
    
    @isTest
    public static void testSetSelectedValue(){
		CreateProjectController CPC = new CreateProjectController();
        String selValue = 'a0041000005w2MfAAI';
        CPC.setSelectedValue(selValue);
    }
    
    @isTest
    public static void testGetChemRegWithProductAndProject(){
        CreateProjectController CPC = new CreateProjectController();
        Project__c project = [SELECT Project__c.Product__r.id,
                              Project__c.Product__r.Tradename__c,
                              Project__c.Product__r.Name,Approval_Status__c,
                              CreatedById,
                              CreatedDate,Department__c,
                              Id,
                              LastModifiedDate,
                              Name,
                              Product__c,
                              Project_Description__c,
                              Project_Type__c,
                              Status__c FROM Project__c];
        CPC.projectRecord = project;
        Product__c varProduct = [select Id, Name, Tradename__c, Product_Description__c from Product__c where Name=:'Sample Product'];
        CPC.setProduct(varProduct);
        List<CreateProjectController.regulatoryWrapper> lstRegWrapper = CPC.getchemReg();
    }
    
    @isTest
    public static void testGetChemRegWithoutProduct(){
        CreateProjectController CPC = new CreateProjectController();
        List<CreateProjectController.regulatoryWrapper> lstRegWrapper = CPC.getchemReg();
    }
    
    @isTest
    public static void testGetPkgSizeWithProductAndProject(){
         CreateProjectController CPC = new CreateProjectController();
        Project__c project = [SELECT Project__c.Product__r.id,
                              Project__c.Product__r.Tradename__c,
                              Project__c.Product__r.Name,Approval_Status__c,
                              CreatedById,
                              CreatedDate,Department__c,
                              Id,
                              LastModifiedDate,
                              Name,
                              Product__c,
                              Project_Description__c,
                              Project_Type__c,
                              Status__c FROM Project__c];
        CPC.projectRecord = project;
        Product__c varProduct = [select Id, Name, Tradename__c, Product_Description__c from Product__c where Name=:'Sample Product'];
        CPC.setProduct(varProduct);
        List<CreateProjectController.pkgSizeWrapper> lstPkgSizeWrapper = CPC.getpkgSize();
    }
    
    @isTest
    public static void testGetPkgSizeWithoutProductAndProject(){
        CreateProjectController CPC = new CreateProjectController();
        List<CreateProjectController.pkgSizeWrapper> lstPkgSizeWrapper = CPC.getpkgSize();
    }
    
    @isTest
    public static void testSaveProductandProjectForNew(){
		    	
		CreateProjectController CPC = new CreateProjectController();
        Opportunity opp = [Select Id from Opportunity];
        CPC.opId = String.valueOf(opp.Id);
        Product__c product  = CPC.getProduct();
        
        Product__c myProduct = new Product__c();
		product.Name = 'Sample';
        product.Tradename__c = 'Some Trade';
        product.Project_Type__c = 'NPI';
        CPC.setProduct(product);

		List<SelectOption> laApplication = CPC.getApplication();
        CPC.setSelectedValue(String.valueOf(laApplication[1].getValue()));        
        
        List<CreateProjectController.regulatoryWrapper> lstRegWrapper = CPC.getchemReg();
        Chem_Regulation__c chemRegVar = [select id,Name from Chem_Regulation__c LIMIT 1];
        lstRegWrapper[0].regulation = chemRegVar;
        lstRegWrapper[0].pmReg = null;
        lstRegWrapper[0].regselected = true;
        
        List<CreateProjectController.pkgSizeWrapper> lstPkgSizeWrapper = CPC.getpkgSize();
        Pkg_Size__c pkgSizeVar = [select Id, Name from Pkg_Size__c];
        lstPkgSizeWrapper[0].pkSize = pkgSizeVar;
        lstPkgSizeWrapper[0].prdtPkg = null;
        lstPkgSizeWrapper[0].pkgselected = true;

		CPC.saveProductAndProject();	
        lstRegWrapper[0].regselected = false;
        lstPkgSizeWrapper[0].pkgselected = false;
        CPC.saveProductAndProject();
        
    }
    
    @isTest
    public static void testSaveProductAndProjectForEdit(){
        CreateProjectController CPC = new CreateProjectController();
        Opportunity opp = [Select Id from Opportunity];
        CPC.opId = String.valueOf(opp.Id);
        Product__c product  = CPC.getProduct();
        
        Product__c myProduct = new Product__c();
		product.Name = 'Sample';
        product.Tradename__c = 'Some Trade';
        product.Project_Type__c = 'NPI';
        CPC.setProduct(product);

		List<SelectOption> laApplication = CPC.getApplication();
        CPC.setSelectedValue(String.valueOf(laApplication[1].getValue()));        
        
        List<CreateProjectController.regulatoryWrapper> lstRegWrapper = CPC.getchemReg();
        Chem_Regulation__c chemRegVar = [select id,Name from Chem_Regulation__c LIMIT 1];
        lstRegWrapper[0].regulation = chemRegVar;
        lstRegWrapper[0].pmReg = null;
        lstRegWrapper[0].regselected = true;
        
        List<CreateProjectController.pkgSizeWrapper> lstPkgSizeWrapper = CPC.getpkgSize();
        Pkg_Size__c pkgSizeVar = [select Id, Name from Pkg_Size__c];
        lstPkgSizeWrapper[0].pkSize = pkgSizeVar;
        lstPkgSizeWrapper[0].prdtPkg = null;
        lstPkgSizeWrapper[0].pkgselected = true;

		CPC.saveProductAndProject();
        
		CreateProjectController.reset = true;
        
        List<SelectOption> lstApplication = CPC.getApplication();
        Product__c productAfterSave  = [select id from Product__c where Name =:'Sample'];
        Project__c projectAfterSave = [select id, Product__c from Project__c where Product__c=:productAfterSave.Id];
        CPC.projectRecord = projectAfterSave; 
        List<CreateProjectController.regulatoryWrapper> lstRegWrapperAfterSave = CPC.getchemReg();
        List<CreateProjectController.pkgSizeWrapper> lstPkgSizeWrapperAfterSave = CPC.getpkgSize();    	    
    }
    
    @isTest
    public static void testSaveAnsSubmitProduct(){
    	CreateProjectController CPC = new CreateProjectController();
        Opportunity opp = [Select Id from Opportunity];
        CPC.opId = String.valueOf(opp.Id);
        Product__c product  = CPC.getProduct();
        
        Product__c myProduct = new Product__c();
		product.Name = 'Sample';
        product.Tradename__c = 'Some Trade';
        product.Project_Type__c = 'NPI';
        CPC.setProduct(product);

		List<SelectOption> laApplication = CPC.getApplication();
        CPC.setSelectedValue(String.valueOf(laApplication[1].getValue()));        
        
        List<CreateProjectController.regulatoryWrapper> lstRegWrapper = CPC.getchemReg();
        Chem_Regulation__c chemRegVar = [select id,Name from Chem_Regulation__c LIMIT 1];
        lstRegWrapper[0].regulation = chemRegVar;
        lstRegWrapper[0].pmReg = null;
        lstRegWrapper[0].regselected = true;
        
        List<CreateProjectController.pkgSizeWrapper> lstPkgSizeWrapper = CPC.getpkgSize();
        Pkg_Size__c pkgSizeVar = [select Id, Name from Pkg_Size__c];
        lstPkgSizeWrapper[0].pkSize = pkgSizeVar;
        lstPkgSizeWrapper[0].prdtPkg = null;
        lstPkgSizeWrapper[0].pkgselected = true;
        
        User u = [select Id from user];
        CPC.selectedUser = String.valueOf(u.Id);
		CPC.saveAndSubmit();    
    }
    
    @isTest
    public static void testSaveAnsSubmitProductNegative(){
    	CreateProjectController CPC = new CreateProjectController();
        Opportunity opp = [Select Id from Opportunity];
        CPC.opId = String.valueOf(opp.Id);
        Product__c product  = CPC.getProduct();
        
        Product__c myProduct = new Product__c();
		product.Name = 'Sample';
        product.Tradename__c = 'Some Trade';
        product.Project_Type__c = 'NPI';
        CPC.setProduct(product);

		List<SelectOption> laApplication = CPC.getApplication();
        CPC.setSelectedValue(String.valueOf(laApplication[1].getValue()));        
        
        List<CreateProjectController.regulatoryWrapper> lstRegWrapper = CPC.getchemReg();
        Chem_Regulation__c chemRegVar = [select id,Name from Chem_Regulation__c LIMIT 1];
        lstRegWrapper[0].regulation = chemRegVar;
        lstRegWrapper[0].pmReg = null;
        lstRegWrapper[0].regselected = true;
        
        List<CreateProjectController.pkgSizeWrapper> lstPkgSizeWrapper = CPC.getpkgSize();
        Pkg_Size__c pkgSizeVar = [select Id, Name from Pkg_Size__c];
        lstPkgSizeWrapper[0].pkSize = pkgSizeVar;
        lstPkgSizeWrapper[0].prdtPkg = null;
        lstPkgSizeWrapper[0].pkgselected = true;
		
		CPC.saveAndSubmit();    
    }
    
    @isTest
    public static void testUpdtaeProjectStatusWithValue(){
        CreateProjectController CPC = new CreateProjectController();
    	Project__c project = [SELECT Project__c.Product__r.id,
                              		Project__c.Product__r.Tradename__c,
                              		Project__c.Product__r.Name,Approval_Status__c,
                              		CreatedById,CreatedDate,Department__c,
                              		Id,
                              		LastModifiedDate,
                              		Name,
                              		Product__c,
                              		Project_Description__c,
                              		Project_Type__c,
                              		Status__c FROM Project__c LIMIT 1];    
        CPC.projectRecord = project;
        CPC.updateProjectStatus();
        System.assertEquals(Label.TerminateMessage,CPC.notificationMessage);
    }
    
    @isTest
    public static void testGetUsersByDept(){
        CreateProjectController CPC = new CreateProjectController();
        CPC.getUsersByDept();
    }
}