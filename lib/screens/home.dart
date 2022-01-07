import 'package:new_app/screens/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map/map_screen.dart';
import 'tab/description.dart';
import 'tab/emergency.dart';



class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
 final FirebaseAuth _auth = FirebaseAuth.instance;
 User user;
 bool isLoggedIn =false;

 checkAuthentication () async{
    _auth.authStateChanges().listen((user) {
      if(user==null){
        Navigator.of(context).pushReplacementNamed("start");
      }
     });
  }

  getUser()async{
   User UserCredential  = _auth.currentUser;
   await UserCredential?.reload();
   UserCredential= _auth.currentUser;

   if(UserCredential!=null){
     setState(() {
       this.user=UserCredential;
       this.isLoggedIn=true;
     });
   }

  }

  signOut()async{
    _auth.signOut();
  }

  TabController _tabController;

  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
    this.getUser();
    _tabController =TabController(length: 2, vsync: this);
  }

  GlobalKey<ScaffoldState>drawerKey=GlobalKey();
    
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      )
    );
    // if(isLoggedIn){
    return Scaffold(
              key:drawerKey,
              appBar: AppBar(
                  backgroundColor: Colors.red[400],
                  elevation: 1,
                  leading:IconButton(
                  icon:Icon(Icons.menu,color:Colors.white),
                  onPressed:(){
                    drawerKey.currentState.openDrawer();
                  }
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search,color: Colors.white,),
                      onPressed:() {},
                  ),                // 
              ],


                  // bottom: TabBar(
                  //   tabs: [
                  //     Tab(
                  //       child: Text('Emergence'),
                  //     ),
                  //     Tab(

                  //       // child: Text('Detail Reports'),
                  //       child: Text(''),
                  //     ),  
                  //   ],
                  //   controller: _tabController,
                  //   //indicator: Colors.black,
                  //   indicatorSize: TabBarIndicatorSize.tab,
                  // ),
                  bottomOpacity: 1,
                ),

                
              drawerEdgeDragWidth: 0,
              //drawer: MainDrawer(),
              drawer:Drawer(
                child:ListView(
                  children:[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          color:Colors.red[400],
                          // borderRadius:BorderRadius.circular(16),
                      ),
                    
                        
                       accountEmail:Text("${_auth.currentUser.email}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0
                        ),),
                     

                      accountName:
                      Text("${_auth.currentUser.displayName}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0
                        ),),
                      
                      currentAccountPicture:ClipRRect(
                        borderRadius:BorderRadius.circular(70),
                        child:
                         Image(
                           image:NetworkImage(""),
                          // image:NetworkImage("https://th.bing.com/th/id/OIP.7R0PTlj7Bd4dcQYePwYjfwHaLp?w=115&h=180&c=7&r=0&o=5&pid=1.7"),
                          width:70,
                          height:70,
                          fit:BoxFit.cover,
                        )
                       
                        ),
                      ),
                  

                    ListTile(
                      title:Text("Home"),
                      leading:Icon(Icons.home_sharp,color:Colors.black),
                      onTap: (){
                          Navigator.of(context).pushReplacementNamed("welcome");
                      },
                    ),
                    
                    ListTile(
                      title:Text("History", ),
                      leading:Icon(Icons.history_edu_outlined, color:Colors.black),
                      onTap: (){
                          Navigator.of(context).pushReplacementNamed("history");
                      },
                    ),
                   
                   ListTile(
                      title:Text("Location"),
                      leading:Icon(Icons.location_on, color:Colors.black,),
                      onTap:(){
                          Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context)=>GoogleMapScreen()));     
                      }
                    
                      //GoogleMapScreen()
                    ),

                     
                    ListTile(
                      title:Text("Admin"),
                      leading:Icon(Icons.admin_panel_settings),
                      onTap: (){
                        Navigator.of(context).pushReplacementNamed("Admin");
                      },
                    ),


                    // ListTile(
                    //   title:Text("Settings"),
                    //   leading:Icon(Icons.settings, color: Colors.black,),
                    //   onTap: (){}    
                    // ),

                    ListTile(
                      title:Text("Sign Out"),
                      leading:Icon(Icons.logout),
                      onTap: (){
                        signOut();
                      }
                    )
                  ]
                )
              ),


            //   //bottom nav
            //     bottomNavigationBar: BottomNavigationBar(
            //   currentIndex: 0, // this will be set when a new tab is tapped
            //   items: [
            //     BottomNavigationBarItem(
            //       icon: new Icon(Icons.home),
            //       title: new Text('Home'),
                  
            //     ),
            //     BottomNavigationBarItem(
            //       icon: new Icon(Icons.history_sharp),
            //       title: new Text('History'),
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.location_on_rounded),
            //       title: Text('Location'),
            //     ),
            //   ],
            //   // type: BottomNavigationBarType.shifting,  
            //   // currentIndex: _selectedIndex,  
            //   // selectedItemColor: Colors.black,  
            //   // iconSize: 40,  
            //   // onTap: _onItemTapped,  
            //   // elevation: 5 
            // ),
            // // ends here 
          
              body:TabBarView(
                    children: <Widget>[
                      EmergencePage(),
                      DetailReportPage(), 
               ],
               controller: _tabController,
             ),
            );
      }
}

