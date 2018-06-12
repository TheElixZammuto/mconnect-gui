using Gtk;
namespace Mconnect{
    public class MconnectGui{

        public static int main (string[] args) {
            try{
            return new MconnectGui().start(args);
            } catch (IOError e){
                
            }
            return 1;
        }

        private int start(string[] args)throws IOError{
            Gtk.init(ref args);
            var manager = get_manager();
            var window = new Window ();
            window.title = "MConnectGUI";
            window.border_width = 10;
            window.window_position = WindowPosition.CENTER;
            window.set_default_size (350, 70);
            window.destroy.connect (Gtk.main_quit);
            /*var box = new Gtk.Box(Orientation.VERTICAL,1);
            foreach (var item in manager.ListDevices()) {
             var device = get_device(item);
             if(device.is_paired){
             var batteryManager = get_battery_manager(item);                 
             var device_box = new Gtk.Box(Orientation.HORIZONTAL,18);
             var batterylabel = new Gtk.Label(batteryManager.level.to_string() + "%");
             var label = new Gtk.Label(device.name);
             device_box.add(label);
             device_box.add(batterylabel);
             box.add(device_box);
             }
            }
            var button_box = new Gtk.Box(Orientation.HORIZONTAL,18);
            var share_button = new Gtk.Button();
            share_button.label = "Share";
            button_box.add(share_button);
            box.add(button_box);
            window.add(box);*/
            var box = new Gtk.Box(Orientation.VERTICAL,16);
            var device_combo = new Gtk.ComboBoxText();
            var device_grid = new Gtk.Grid();
            var label_name = new Gtk.Label("ciao");
            var label_connected = new Gtk.Label("false");
            var label_battery = new Gtk.Label("0%");
            box.add(device_combo);
            for(int i = 0;i<manager.ListDevices().length;i++){
                var deviceItem = manager.ListDevices()[i];
                var device = get_device(deviceItem);
                device_combo.append(i.to_string(),device.name);
            }
            device_combo.changed.connect (() => {
                int i  = int.parse(device_combo.get_active_id());
                var deviceItem = manager.ListDevices()[i];
                var device = get_device(deviceItem);
                var battery = get_battery_manager(deviceItem);
                var battery_str = battery.level.to_string() + "%";
                if(battery.charging) battery_str += " C";
                label_name.label = device.name;
                label_connected.label = device.is_connected.to_string();
                label_battery.label = battery_str;
            });
            device_grid.attach(new Gtk.Label("Name:"),0,0,1,1);
            device_grid.attach(label_name,1,0,1,1);
            device_grid.attach(new Gtk.Label("Connected:"),0,1,1,1);
            device_grid.attach(label_connected,1,1,1,1);
            device_grid.attach(new Gtk.Label("Battery Level:"),0,2,1,1);
            device_grid.attach(label_battery,1,2,1,1);
            window.add(box);
            box.add(device_grid);
            window.show_all ();
            Gtk.main ();
            return 0;
        }

        private DeviceManagerIface ? get_manager () throws IOError {
            return get_mconnect_obj_proxy (
                new ObjectPath (DeviceManagerIface.OBJECT_PATH));
        }

        private DeviceIface ? get_device (ObjectPath path) throws IOError {
            return get_mconnect_obj_proxy (path);
        }

        private T ? get_mconnect_obj_proxy<T>(ObjectPath path) throws IOError {
            T proxy_out = null;
            try {
                proxy_out = Bus.get_proxy_sync (BusType.SESSION,
                                                "org.mconnect",
                                                path);
            } catch (IOError e) {
                warning ("failed to obtain proxy to mconnect service: %s",
                         e.message);
                throw e;
            }
            return proxy_out;
        }

        private BatteryIFace get_battery_manager(ObjectPath path) throws IOError{
            return get_mconnect_obj_proxy(path);
        }
    }
}