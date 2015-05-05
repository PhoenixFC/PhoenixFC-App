#import <Foundation/Foundation.h>
#import "ORSSerialPort.h"

typedef struct _RxPacket
{
    NSInteger channel1;
    NSInteger channel2;
    NSInteger channel3;
    NSInteger channel4;
    NSInteger channel5;
    NSInteger channel6;
} RxPacket;

typedef struct _SensorPacket
{
    NSInteger accel_x;
    NSInteger accel_y;
    NSInteger accel_z;
    NSInteger gyro_x;
    NSInteger gyro_y;
    NSInteger gyro_z;
} SensorPacket;

@protocol FlightControllerDelegate
@optional
- (void)flightControllerConsoleDidChange:(NSString *)value;
- (void)flightControllerDidReceiveRxPacket:(RxPacket)packet;
- (void)flightControllerDidReceiveRawRxPacket:(RxPacket)packet;
- (void)flightControllerDidReceiveSensorPacket:(SensorPacket)packet;
@end

@interface FlightController : NSObject <ORSSerialPortDelegate>

@property (strong) ORSSerialPort *serialPort;
@property (strong) NSMutableString *consoleOutput;
@property (weak) NSObject<FlightControllerDelegate> *delegate;

- (void)connect;
- (void)disconnect;
- (BOOL)isConnected;

- (void)sendRxRequest;
- (void)sendRawRxRequest;
- (void)sendSensorRequest;

@end
