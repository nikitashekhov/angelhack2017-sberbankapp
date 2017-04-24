# Import file "Screens" (sizes and positions are scaled 1:2)
sketch = Framer.Importer.load("imported/Screens@2x")
page = new PageComponent
   scrollVertical: false
   scrollHorizontal: true
   x: 0
   y: 0
   width: 375*2
   height: 667*2
buy = 0
# Create a PageComponent 
page.addPage(sketch.Main)
page.addPage(sketch.Company_Main)
page.addPage(sketch.Company_Intro)
page.addPage(sketch.Company_History)
page.addPage(sketch.Company_PayMap)
page.addPage(sketch.Company_Inquire)
page.addPage(sketch.Company_Inquire_Modal)
page.addPage(sketch.Inquire_Modal)
page.addPage(sketch.Inquire)
page.addPage(sketch.PayMap_Company)
page.addPage(sketch.PayMap)
page.addPage(sketch.History)
page.addPage(sketch.Payment)
page.addPage(sketch.Payment_Company)
page.addPage(sketch.Notification)
page.addPage(sketch.Notification_Company)



flow = new FlowComponent
sketch.succ.opacity = 0
sketch.rej.opacity = 1

# payment history scroll
historyScroll = new ScrollComponent
    width: 375*2
    height: (628-145-29)*2
    x: 0
    y: 145*2
    scrollHorizontal: false
    scrollVertical: true

sketch.Operations.parent = historyScroll.content
sketch.Operations.y = 0
sketch.History.addChild(historyScroll)
sketch.Today.opacity = 0
sketch.get750.opacity = 0
sketch.pay135.opacity = 0
sketch.pay1500.opacity = 0

# map scroll
personMapScroll = new ScrollComponent
    width: 375*2
    height: (628-75-29)*2
    x: 0
    y: 145
    scrollHorizontal: true
    scrollVertical: true
personMap = sketch.PayMapPeople

personMap.parent = personMapScroll.content
sketch.PayMap.addChild(personMapScroll)	
rafael = sketch.Rafael
rafael.opacity = 1
rafael.states.fade =
	opacity: 0
rafael.states.unfade =
	opacity: 1
	scale: 2
rafael.states.disfade =
	opacity: 1
	scale: 1
rafael.states.buy =  0
sketch.PayMap.addChild(rafael)
rafael.placeBefore(personMapScroll)

# map scroll
personShopMapScroll = new ScrollComponent
    width: 375*2
    height: (628-75-29)*2
    x: 0
    y: 145
    scrollHorizontal: true
    scrollVertical: true
personShopMap = sketch.People1
#personMap.y = 0
personShopMap.parent = personShopMapScroll.content
sketch.PayMap_Company.addChild(personShopMapScroll)	
# rafael icon floating around
rafaelShop = sketch.PayPlease
rafaelShop.opacity = 1
rafaelShop.states.fade =
	opacity: 1
rafaelShop.states.unfade =
	opacity: 1
	scale: 2.5
rafaelShop.states.disfade =
	opacity: 1
	scale: 1

sketch.PayMap_Company.addChild(rafaelShop)
rafaelShop.placeBefore(personShopMapScroll)

# rafael enters sber and asks for money
#on client creates on map for shop
flow.onClick -> 
	if flow.current.name == "PayMap_Company" && false
		Utils.delay .2, -> 
			rafaelShop.animate("unfade")
			Utils.delay 1, -> 
				rafaelShop.animate("disfade")
				Utils.delay 1, -> 
					flow.showNext(sketch.Notification_Company)
#on person creates on map
flow.onClick -> 
	if flow.current.name == "PayMap"
		if(buy == 1)
			buy = 0
			flow.showNext(sketch.PayMap_Company)
			if flow.current.name == "PayMap_Company"
				Utils.delay .2, -> 
					rafaelShop.animate("unfade")
					Utils.delay 1, -> 
						rafaelShop.animate("disfade")
						Utils.delay 1, -> 												flow.showNext(sketch.Notification_Company)
		else if buy == 0
			if rafael.opacity == 1
				Utils.delay .2, -> 
					rafael.animate("unfade")
					Utils.delay 1, -> 
						rafael.animate("disfade")
						Utils.delay 2, -> 
							rafael.animate("fade")
							buy =  1
							rafael.opacity = 0
							flow.showNext(sketch.Inquire)
			if rafael.opacity == 0
				Utils.delay .2, -> 
					rafael.animate("unfade")
					Utils.delay 1, -> 
						rafael.animate("disfade")
						Utils.delay 2, -> 
							rafael.animate("fade")
							
							rafael.opacity = 0
							flow.showNext(sketch.Notification)
		
			
					
# on payment
flow.onClick -> 
	if flow.current.name == "Inquire_Modal"
		Utils.delay 2, ->
			sketch.succ.opacity = 1
			sketch.rej.opacity = 0 
			Utils.delay 1, -> 
				
				flow.showNext(sketch.History)
				sketch.Today.opacity = 1
				sketch.Yesterday.opacity = 1
				sketch.DaysAgo.opacity = 1	
			
# buttons on notification page
payToRafael = new Layer
	x: 60*2
	y: 320*2
	width: 150*2
	height: 200*2
	opacity: 0
sketch.Notification.addChild(payToRafael)
payToRafael.onClick ->
	flow.showNext(sketch.Payment)
	
payToRafaelShop = new Layer
	x: 60*2
	y: 320*2
	width: 150*2
	height: 200*2
	opacity: 0
sketch.Notification_Company.addChild(payToRafaelShop)
payToRafaelShop.onClick ->
	flow.showNext(sketch.Payment_Company)
#reject payment
rejectPayToRafael = new Layer
	x: 220*2
	y: 320*2
	width: 150*2
	height: 200*2
	opacity: 0
sketch.Notification.addChild(rejectPayToRafael)
sketch.Notification_Company.addChild(rejectPayToRafael)
rejectPayToRafael.onClick ->
	flow.showNext(sketch.Main)
	
#payment accept
askPayShop = new Layer
	x: 50
	y: 480*2
	height: 250
	width: 330*2
	opacity: 0
sketch.Payment_Company.addChild(askPayShop)
askPayShop.onClick ->
	flow.showNext(sketch.History)
	sketch.get750.y = sketch.get750.y + 120*2
	sketch.pay135.opacity = 1
	sketch.pay135.y = 100
	sketch.Yesterday.y = sketch.Yesterday.y + 120*2
	sketch.DaysAgo.y = sketch.DaysAgo.y + 120*2
	
#payment to company accept
askPay = new Layer
	x: 50
	y: 480*2
	height: 250
	width: 330*2
	opacity: 0
sketch.Payment.addChild(askPay)
askPay.onClick ->
	flow.showNext(sketch.History)
	sketch.get750.y = sketch.get750.y + 120*2
	sketch.pay1500.opacity = 1
	sketch.pay1500.y = 100
	sketch.pay135.y = sketch.pay135.y + 120*2
	sketch.Yesterday.y = sketch.Yesterday.y + 120*2
	sketch.DaysAgo.y = sketch.DaysAgo.y + 120*2

		
#payment 2(inquire)
askPay2 = new Layer
	x: 50
	y: 280*2
	height: 350
	width: 330*2
	opacity: 0
sketch.Inquire.addChild(askPay2)
askPay2.onClick ->
	flow.showNext(sketch.Inquire_Modal)
	sketch.Today.opacity = 1
	sketch.get750.opacity = 1
	sketch.get750.y = 100
	sketch.Yesterday.y = sketch.Yesterday.y + 100 + 120*2+30
	sketch.DaysAgo.y = sketch.DaysAgo.y + 100 + 120*2+30
	


#sketch.PayMap.addChild(personMapScroll)
	


#history page
historyButton = new Layer
	x: 375*2/5*2
	y: 609*2
	width: 375*2/5
	height: 140
	opacity: 0
# sketch.Main.addChild(historyButton)
# sketch.History.addChild(historyButton)
# sketch.Payment.addChild(historyButton)
# sketch.PayMap.addChild(historyButton)
# sketch.Notification.addChild(historyButton)
# sketch.Inquire.addChild(historyButton)
# sketch.Inquire_Modal.addChild(historyButton)
# sketch.PayMap_Company.addChild(historyButton)
# sketch.Notification_Company.addChild(historyButton)
# sketch.Payment_Company.addChild(historyButton)
historyButton.onClick -> 
	flow.showNext(sketch.History)
#main page
mainButton = new Layer
	x: 0
	y: 609*2
	width: 375*2/5
	height: 140
	opacity: 0

# sketch.Main.addChild(mainButton)
# sketch.History.addChild(mainButton)
# sketch.Payment.addChild(mainButton)
# sketch.PayMap.addChild(mainButton)
# sketch.Notification.addChild(mainButton)
# sketch.Inquire.addChild(mainButton)
# sketch.Inquire_Modal.addChild(mainButton)
# sketch.PayMap_Company.addChild(mainButton)
# sketch.Notification_Company.addChild(mainButton)
# sketch.Payment_Company.addChild(mainButton)
mainButton.onClick -> 
	flow.showNext(sketch.Main)
#pay map
payButton = new Layer
	x: 375*2/5*3
	y: 609*2
	width: 375*2/5
	height: 140
	opacity: 0
# 
# sketch.Main.addChild(payButton)
# sketch.History.addChild(payButton)
# sketch.Payment.addChild(payButton)
# sketch.PayMap.addChild(payButton)
# sketch.Notification.addChild(payButton)
# sketch.Inquire.addChild(payButton)
# sketch.Inquire_Modal.addChild(payButton)
# sketch.PayMap_Company.addChild(payButton)
# sketch.Notification_Company.addChild(payButton)
# sketch.Payment_Company.addChild(payButton)
payButton.onClick -> 
	flow.showNext(sketch.PayMap)
	
#Company button map
CompBut = new Layer
	x: 182
	y: 80
	width: 375
	height: 300
	opacity: 0
sketch.Main.addChild(CompBut)
CompBut.onClick -> 
	flow.showNext(sketch.Company_Intro)
	Utils.delay 2, -> 
			flow.showNext(sketch.Company_Main)

flow.showNext(sketch.Main)
