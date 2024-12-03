import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import vibrator from "@ohos.vibrator";
import { BusinessError } from '@kit.BasicServicesKit';

/** FlutterVibratePlugin **/
export default class FlutterVibratePlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  hasVibrator: boolean = false;
  constructor() {
  }

  getUniqueClassName(): string {
    return "FlutterVibratePlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "vibrate");
    this.channel.setMethodCallHandler(this)
    this.hasVibrator = vibrator.isHdHapticSupported();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }
  vibrate(duration: number): void {
    vibrator.startVibration({
      type: 'time',
      duration: duration,
    }, {
      id: 0,
      usage: 'alarm'
    }, (error: BusinessError) => {
      if (error) {
        console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
        return;
      }
      console.info('Succeed in starting vibration');
    });
  }
  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "canVibrate":
        result.success(true);
        break;
      case "vibrate":
        let duration:number = call.argument("duration");
        this.vibrate(duration);
        result.success(null);
        break;
      case "impact":
        this.vibrate(2);
        result.success(null);
        break;
      case "selection":
        this.vibrate(3);
        result.success(null);
        break;
      case "success":
        this.vibrate(50);
        result.success(null);
        break;
      case "warning":
        this.vibrate(250);
        result.success(null);
        break;
      case "error":
        this.vibrate(500);
        result.success(null);
        break;
      case "heavy":
        this.vibrate(100);
        result.success(null);
        break;
      case "medium":
        this.vibrate(40);
        result.success(null);
        break;
      case "light":
        this.vibrate(10);
        result.success(null);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}