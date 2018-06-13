using Gtk;
namespace Mconnect{
    public class MconnectGui{
        DeviceManagerIface manager;
        Gtk.Window window;
        Gtk.Box box;
        Gtk.ComboBoxText device_combo;
        Gtk.Grid device_grid;
        Gtk.Label label_name;
        Gtk.Label label_connected;
        Gtk.Label label_battery;
        bool is_device_selected = false;
        GLib.ObjectPath selected_device = null;

        public static int main (string[] args) {
            try{
            return new MconnectGui().start(args);
            } catch (IOError e){
                
            }
            return 1;
        }

        private int start(string[] args)throws IOError{
            Gtk.init(ref args);
            manager = get_manager();
            init_gui();
            Gtk.main ();
            return 0;
        }

        private void on_device_selected(){
            int i  = int.parse(device_combo.get_active_id());
            is_device_selected = true;
            selected_device = manager.ListDevices()[i];
            update_gui();
        }

        private void update_gui(){
            device_grid.visible = is_device_selected;
            if(is_device_selected){
                var device = get_device(selected_device);
                var battery = get_battery_manager(selected_device);
                var battery_str = battery.level.to_string() + "%";
                if(battery.charging) battery_str += " C";
                label_name.label = device.name;
                label_connected.label = device.is_connected.to_string();
                label_battery.label = battery_str;
            }
        }

        private void init_gui(){
            window = new Window ();
            window.title = "MConnectGUI";
            window.border_width = 10;
            window.window_position = WindowPosition.CENTER;
            window.set_default_size (350, 70);
            window.destroy.connect (Gtk.main_quit);
            box = new Gtk.Box(Orientation.VERTICAL,16);
            device_combo = new Gtk.ComboBoxText();
            device_grid = new Gtk.Grid();
            label_name = new Gtk.Label("");
            label_connected = new Gtk.Label("");
            label_battery = new Gtk.Label("");
            box.add(device_combo);
            for(int i = 0;i<manager.ListDevices().length;i++){
                var deviceItem = manager.ListDevices()[i];
                var device = get_device(deviceItem);
                device_combo.append(i.to_string(),device.name);
            }
            device_combo.changed.connect (() => {
                on_device_selected();
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
            update_gui();
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