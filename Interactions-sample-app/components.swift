import Foundation
import Interactions

struct ComponentList: Scene {
    let title = "Components"
    var body: some Renderable {
        NavigationLink(key: .n1, label: "Table", destination: TableDemo())
        NavigationLink(key: .n2, label: "Button", destination: ButtonDemo())
        NavigationLink(key: .n3, label: "TabView", destination: TabDemo())
        NavigationLink(key: .n4, label: "Alert", destination: AlertDemo())
        NavigationLink(key: .n5, label: "NumberField", destination: NumberFieldDemo())
        NavigationLink(key: .n6, label: "List", destination: ListDemo())
        NavigationLink(key: .n7, label: "Slider", destination: SliderDemo())

        List(.n0) {
            NavigationStack {
                NavigationLink("In list") {
                    Text("List")
                }
            }
        }
        NavigationStack {
            NavigationLink(key: .n8, "Outside") {
                Text("Outside")
            }
        }
    }
}

struct TableDemo: Scene {
    let title = "Table"
    let data = ["a", "b", "c", "d"]
    var body: some Renderable {
        Table(data) {
            TableColumn<String>("Lowercase") { row in
                Text(row)
            }
            TableColumn<String>("Uppercase") { row in
                Text(row.uppercased())
            }
        }
    }
}

struct ButtonDemo: Scene {
    let title = "Button"

    var body: some Renderable {
        Button(.n1, "Press me with 1") {
            print("Button pressed")
        }
    }
}

struct TabDemo: Scene {
    let title = "Tab View"

    var body: some Renderable {
        TabView(tabs: [
            TabItem(title: "Tab A") {
                Text("Tab A")
            },
            TabItem(title: "Tab B") {
                Text("Tab B")
            }
        ])
    }
}

struct AlertDemo: Scene {
    let title = "Alert"
    @State private var showAlert = false
    
    var body: some Renderable {
        VStack {
            Button(.cD, "Show alert") {
                showAlert = true
            }
            Text("\nThis text will be behind the alert.")
            Alert(title: "Alert title", text: "Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They’re not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. But the only thing you can’t do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, We see genius. Because the people who are crazy enough to think they can change the world, Are the ones who do.", level: .info, isPresented: $showAlert)
        }
    }
}

struct NumberFieldDemo: Scene {
    let title = "NumberField"
    @State private var number = 0

    var body: some Renderable {
        VStack {
            NumberField(.n1, "Enter a number", number: $number)
            Text("Doubled: \(number*2)")
        }
    }
}

struct ListDemo: Scene {
    let title = "List"
    @State private var isOn = false
    @State private var value = 0
    
    var body: some Renderable {
        List(.n1, "List title") {
            Button("Button") {
                print("Hello!")
            }
            Text("This is just a text.")
            Toggle(isOn: $isOn)
            NavigationLink(label: "NavigationLink", destination: ButtonDemo())
            Slider(value: $value, in: 0...100, label: "Slider")
        }
    }
}

struct SliderDemo: Scene {
    let title = "Slider"
    @State private var value = 0
    var body: some Renderable {
        Slider(key: .n1, value: $value, label: "Slider", step: 2)
        Text("Value: \(value)")
    }
}
