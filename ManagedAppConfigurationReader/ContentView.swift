import SwiftUI

struct ContentView: View {
    @State var managedAppConfig = [String: String]()
    @AppStorage("AutoLogin") var autoLoginStatus: Bool = false
    @AppStorage("LoginUsername") var loginUserName: String = "No User"
    @AppStorage("LoginPassword") var loginUserPassword: String = "No User"
//    func defaultsChanged(){
//        }
//    deinit { //Not needed for iOS9 and above. ARC deals with the observer in higher versions.
//            NotificationCenter.default.removeObserver(self)
//    }
    
//    init(){
//
//                NotificationCenter.default.addObserver(self, selector: #selector(ContentView.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
//                defaultsChanged()
//    }
    
    var body: some View {
        VStack {
            Text("eParlKenya Configuration").font(.title)
            List{
                Text("Auto Login Status: \((autoLoginStatus) ? "True" : "False")").font(.title)
                Text("User: \(loginUserName)").font(.title)
                Text("Password: \(loginUserPassword) ").font(.title)
            }
            ScrollView {
                if managedAppConfig.keys.isEmpty == true {
                    Text("No Managed Configuration found").padding()
                } else {
                    ForEach(managedAppConfig.sorted(by: >), id: \.key) { key, value in
                        VStack(alignment: .leading) {
                            KeyValueView(key: key, value: value)
                            Divider()
                        }.padding()
                    }
                }
            }.hidden()
        }
        .onAppear {
            
            SettingsBundleHelper.setVersionAndBuildNumber()
            managedAppConfig = SettingsBundleHelper.checkAndExecuteSettings()
            
//            managedAppConfig["Anand"] = "Upadhyay"
            
//            guard let dictionary = UserDefaults.standard.object(
//                forKey: "com.apple.configuration.managed"
//            ) as? [String: Any?] else { return }
//            managedAppConfig = dictionary.compactMapValues { $0 as? String }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class SettingsBundleHelper {
    
    struct SettingsBundleKeys {
        static let AutoLogin = "AutoLogin"
        static let LoginUsername = "LoginUsername"
        static let LoginPassword = "LoginPassword"
        static let AppName = "AppName"
        static let AppVersion = "AppVersion"
    }
    
    class func checkAndExecuteSettings()->[String:String]{
        var managedAppConfig = [String: String]()
            
        managedAppConfig[SettingsBundleKeys.AutoLogin] = UserDefaults.standard.bool(forKey: SettingsBundleKeys.AutoLogin) ? "True" : "False"
            managedAppConfig[SettingsBundleKeys.LoginUsername] = UserDefaults.standard.value(forKey: SettingsBundleKeys.LoginUsername) as? String
            managedAppConfig[SettingsBundleKeys.LoginPassword] = UserDefaults.standard.value(forKey: SettingsBundleKeys.LoginPassword) as? String
        return managedAppConfig
    }
    
    class func setVersionAndBuildNumber() {
    let systemBuildVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    let savedBuildVersion = UserDefaults.standard.value(forKey: SettingsBundleKeys.AppVersion) as? String
        //For the First Installation
        if savedBuildVersion != nil {
            //For subsequent installation if we want to override the settings then
            if savedBuildVersion! == systemBuildVersion {
                // No Need to write anything as the device already has the latest configuration
                print("No Need to Setup Settings")
            }else{
                SettingsBundleHelper.addDefaultSettings()
                
            }
        }else{
            SettingsBundleHelper.addDefaultSettings()//rewrite the settings as its th First time isntallation
        }
    }
    
    class func addDefaultSettings(){
        let systemBuildVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set(systemBuildVersion, forKey: SettingsBundleKeys.AppVersion)
        let savedBuildVersion = UserDefaults.standard.value(forKey: SettingsBundleKeys.AppVersion)
        print("saved appversion \(String(describing: savedBuildVersion))")
        let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
        
        UserDefaults.standard.set(appName, forKey: SettingsBundleKeys.AppName)
        UserDefaults.standard.set("psc_admin", forKey: SettingsBundleKeys.LoginUsername)
        UserDefaults.standard.set("psc_admin", forKey: SettingsBundleKeys.LoginPassword)
        UserDefaults.standard.set(true, forKey: SettingsBundleKeys.AutoLogin)
        
    }
}
//xcrun simctl spawn booted defaults write com.stl.AppConfigTest com.apple.configuration.managed -dict
//xcrun simctl spawn booted defaults write com.stl.AppConfigTest com.apple.configuration.managed -dict 'LoginUsername' 'psc_admin'
//xcrun simctl spawn booted defaults write com.stl.AppConfigTest com.apple.configuration.managed -dict 'AutoLogin' 'True' 'LoginUsername' 'psc_admin' 'LoginPassword' 'psc_admin'
