package android.os.nvram;

import android.os.RemoteException;
import android.os.ServiceManager;

/**
 * Created by TRF1309 on 2017-01-19.
 */
public class NvRAMUtils {
    
    private static final NvRAMAgent mAgent = NvRAMAgent.Stub.asInterface(ServiceManager.getService("NvRAMAgent"));
    private static final String TAG = "NvRAMUtils";

    public static final int UNIFIED_LID = 59;

    /***** NvRAMUtils - Place your offset below *****/
    //@Description: Ensure there is no duplicated offset declared!
    // NV offset - Please Try to use the index between 1024 - 2047
    public static final int NV_OFFSET = 1024;
    
    /// Xunhu: ImeiSettings at 2017-02-16 10:50:02 by QinTuanye{{&&	
    /// Description: 添加IMEI1和IMEI2 NV下标
    public static final int INDEX_SIM1_IMEI = 64;
    public static final int INDEX_SIM2_IMEI = 74;
    public static final int SIM1_IMEI_LENGTH = 10;
    public static final int SIM2_IMEI_LENGTH = 10;
    ///&&}}
    
    // Declared offsets above should be included in this integer array, otherwise verification and I/O afterwards will fail
    private static final int[] INDEX_LIST = {
			/// Xunhu: ImeiSettings at 2017-02-16 10:50:02 by QinTuanye{{&&	
			/// Description: 添加IMEI1和IMEI2 NV下标
			INDEX_SIM1_IMEI,
            INDEX_SIM2_IMEI,
            ///&&}}
    };

    /***** NvRAMUtils - Place your offset above *****/

    /***** NvRAMUtils - Generic I/O Methods begin *****/
    /**
     * Read the specific index in NvRAM
     * @param index the position that need to be accessed
     * @return the byte written in the index, -1 when read failed
     */
    public synchronized static byte readNV(int index) throws RemoteException {
        byte result = -1;
        if(!verifyIndex(index)) {
            android.util.Log.d(TAG,"Argument: " + index + "is not declared in INDEX_LIST! Read failed");
            return result;
        }
        byte[] buff = readNV();
        if (buff != null && index < buff.length) {
            result = buff[index];
        }
        return result;
    }
    /**
     * Read the specific range in NvRAM
     * @param index the start index that need to be accessed
     * @param length from the start index, the length of the range that need to be accessed
     * @return the byte array written in the specified range, null when read failed
     */
    public synchronized static byte[] readNV(int index, int length) throws RemoteException {
        if(!verifyIndex(index)) {
            android.util.Log.d(TAG,"Argument: " + index + "is not declared in INDEX_LIST! Read failed");
            return null;
        }
        byte[] buff = readNV();
        byte[] target = new byte[length];
        for(int i = 0 ; i < length; i++){
            target[i] = buff[i+index];
        }
        return target;
    }

    /**
     * Read all the data in NvRAM
     * @return the byte array(usually with length of 2048) containing all the bytes in NvRAM, null when read failed.
     */
    public synchronized static byte[] readNV() throws RemoteException {
        return mAgent.readFile(UNIFIED_LID);
    }

    /**
     * write a specified byte in a specified position
     * @param index the position that need to be written
     * @param value the value that need to be written
     * @return true when write succeeded, false when write failed
     */
    public synchronized static boolean writeNV(int index, byte value) throws RemoteException {
        if(!verifyIndex(index)) {
            android.util.Log.d(TAG,"Argument: " + index + "is not declared in INDEX_LIST! Write failed");
            return false;
        }
        boolean result = false;
        byte[] buff = readNV();
        if (buff != null && index < buff.length) {
            buff[index] = value;
            result = writeNV(buff);
        }
        return result;
    }

    /**
     * write a specified byte array into NvRAM, start with the specified index
     * @param index the start position that need to be written
     * @param buff the values that need to be written from the start position
     * @return true when write succeeded, false when write failed
     */
    public synchronized static boolean writeNV(int index, byte[] buff) throws RemoteException {
        if(!verifyIndex(index)) {
            android.util.Log.d(TAG,"Argument: " + index + "is not declared in INDEX_LIST! Write failed");
            return false;
        }
        boolean result = false;
        byte[] origin = readNV();
        if (buff != null && origin != null && (index + buff.length) < origin.length) {
            for(int i = 0 ; i < buff.length; i++){
                origin[index+i] = buff[i];
            }
            result = writeNV(origin);
        }
        return result;
    }

    /**
     * overwrite all the data in NvRAM
     * @param buff the byte array(usually with length of 2048) containing all the bytes in NvRAM
     * @return true when write succeeded, false when write failed
     */
    public synchronized static boolean writeNV(byte[] buff) throws RemoteException {
        boolean result = false;
        if (buff != null) {
            result = mAgent.writeFile(UNIFIED_LID, buff) > 0;
        }
        return result;
    }

    /**
     * read and return an integer converted base on 4 continuous bytes
     * @param index the starting position in NvRAM
     * @return the integer value converted from 4 continuous bytes
     */
    public synchronized static int readInt(int index) throws RemoteException {
        byte[] buff = readNV(index, 4);
        if(buff == null || buff.length != 4){
            return -1;
        }
        return bytes2Int(buff);
    }

    /**
     * write an integer into 4 continuous bytes
     * @param index the starting position in NvRAM
     * @param value the integer value that need to be written
     * @return true when write succeeded, false when write failed
     */
    public synchronized static boolean writeInt(int index, int value) throws RemoteException {
        byte[] buff = int2Bytes(value);
        return writeNV(index,buff);
    }

    /**
     * Private method to convert from byte array into integer
     * @param byteArray the target byte array that need to be converted
     * @return the integer that converted from target byte array
     */
    private static int bytes2Int(byte[] byteArray) {
        int result = 0;
        if (byteArray.length != 4) {
            return result;
        }
        for (byte byteVal : byteArray) {
            result = (result << 8) | (byteVal & 255);
        }
        return result;
    }

    /**
     * Private method to convert from integer into byte array
     * @param intVal the target integer value that need to be converted
     * @return the byte array that converted from target integer
     */
    private static byte[] int2Bytes(int intVal) {
        byte[] result = new byte[4];
        if (intVal == 0) {
            return result;
        }
        for (int i = 0; i < result.length; i++) {
            result[result.length - i - 1] = (byte) (intVal & 255);
            intVal = intVal >> 8;
        }
        return result;
    }

    private synchronized static boolean verifyIndex(int index){
        //ZDP - To check whether the index is declared in the Array INDEX_LIST
        for(int i = 0 ; i < INDEX_LIST.length; i++){
            if(INDEX_LIST[i] == index){
                return true;
            }
        }
        return false;
    }
    /***** NvRAMUtils - Generic I/O Methods end *****/
}
