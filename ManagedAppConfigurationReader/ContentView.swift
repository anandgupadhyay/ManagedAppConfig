import SwiftUI

struct ContentView: View {
    @State var managedAppConfig = [String: String]()
    var body: some View {
        VStack {
            Text("eParlKenya Configuration").font(.title)
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
            }
        }
        .onAppear {
            guard let dictionary = UserDefaults.standard.object(
                forKey: "com.apple.configuration.managed"
            ) as? [String: Any?] else { return }
            managedAppConfig = dictionary.compactMapValues { $0 as? String }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//xcrun simctl spawn booted defaults write com.stl.AppConfigTest com.apple.configuration.managed -dict
//xcrun simctl spawn booted defaults write com.stl.AppConfigTest com.apple.configuration.managed -dict 'LoginUsername' 'psc_admin'
//xcrun simctl spawn booted defaults write com.stl.AppConfigTest com.apple.configuration.managed -dict 'AutoLogin' 'True' 'LoginUsername' 'psc_admin' 'LoginPassword' 'psc_admin'
