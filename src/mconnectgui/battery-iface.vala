namespace Mconnect { 
    [DBus (name = "org.mconnect.Device.Battery")]
    public interface BatteryIFace : Object { 
        
        public abstract uint level{
            owned get;
        }

        public abstract bool charging{
            owned get;
        }
    }
}