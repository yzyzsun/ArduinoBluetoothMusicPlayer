#include <SD.h>
#include <SPI.h>
#include <MusicPlayer.h>

#define STEP (MAXVOL / 16)
#define BOUND MAXVOL

typedef enum {
  MP_PAUSE = 'a',
  MP_RESUME,
  MP_BACKWARD,
  MP_FORWARD,
  MP_PREV,
  MP_NEXT,
  MP_VOL_UP,
  MP_VOL_DOWN,
  MP_VOL_CHANGE,
  MP_MODE_NORMAL,
  MP_MODE_SHUFFLE,
  MP_MODE_LIST,
  MP_MODE_SINGLE
} MPCommand;

void setup() {
  Serial.begin(115200);
  player.begin();
  player.setPlayMode(PM_NORMAL_PLAY);
  player.setVolume(BOUND / 2);
  player.scanAndPlayAll();
}

void loop() {
  // vol is in fact reversed
  // constant SILENT(0) stands for maximum vol
  // as MAXVOL(254) stands for minimum vol
  static unsigned char vol = BOUND / 2;
  
  if (Serial.available()) {
    MPCommand cmd = (MPCommand)Serial.read();
    switch (cmd) {
    case MP_PAUSE:
      Serial.write("[Pause]\r\n");
      player.opPause();
      break;
    case MP_RESUME:
      Serial.write("[Resume]\r\n");
      player.opResume();
      break;
    case MP_BACKWARD:
      player.opFastRewind();
      break;
    case MP_FORWARD:
      player.opFastForward();
      break;
    case MP_PREV:
      player.opPreviousSong();
      break;
    case MP_NEXT:
      player.opNextSong();
      break;
    case MP_VOL_UP:
      if (vol < STEP) vol = 0;
      else vol -= STEP;
      player.setVolume(vol);
      break;
    case MP_VOL_DOWN:
      if (vol > BOUND - STEP) vol = BOUND;
      else vol += STEP;
      player.setVolume(vol);
      break;
    case MP_VOL_CHANGE:
      while (!Serial.available());
      vol = map(Serial.read(), 0, 16, MAXVOL, SILENT);
      player.setVolume(vol);
      break;
    case MP_MODE_NORMAL:
      Serial.write("Mode changed to Normal\r\n");
      player.setPlayMode(PM_NORMAL_PLAY);
      break;
    case MP_MODE_SHUFFLE:
      Serial.write("Mode changed to Shuffle\r\n");
      player.setPlayMode(PM_SHUFFLE_PLAY);
      break;
    case MP_MODE_LIST:
      Serial.write("Mode changed to RepeatList\r\n");
      player.setPlayMode(PM_REPEAT_LIST);
      break;
    case MP_MODE_SINGLE:
      Serial.write("Mode changed to RepeatSingle\r\n");
      player.setPlayMode(PM_REPEAT_ONE);
      break;
    }
  }
  
  player.play();
}
