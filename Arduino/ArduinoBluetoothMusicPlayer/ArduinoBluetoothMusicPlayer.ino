#include <SD.h>
#include <SPI.h>
#include <MusicPlayer.h>

typedef enum {
  MP_PLAY = 'a',
  MP_PAUSE,
  MP_BACKWARD,
  MP_FORWARD,
  MP_PREV,
  MP_NEXT,
  MP_VOL_UP,
  MP_VOL_DOWN,
  MP_MODE_NORMAL,
  MP_MODE_SHUFFLE,
  MP_MODE_LIST,
  MP_MODE_SINGLE
} MPCommand;

void setup() {
  Serial.begin(115200);
  player.begin();
  player.setPlayMode(PM_NORMAL_PLAY);
  player.scanAndPlayAll();
}

void loop() {
  if (Serial.available()) {
    MPCommand cmd = (MPCommand)Serial.read();
    switch (cmd) {
    case MP_PLAY:
      player.opResume();
      break;
    case MP_PAUSE:
      player.opPause();
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
      player.opVolumeUp();
      break;
    case MP_VOL_DOWN:
      player.opVolumeDown();
      break;
    case MP_MODE_NORMAL:
      player.setPlayMode(PM_NORMAL_PLAY);
      break;
    case MP_MODE_SHUFFLE:
      player.setPlayMode(PM_SHUFFLE_PLAY);
      break;
    case MP_MODE_LIST:
      player.setPlayMode(PM_REPEAT_LIST);
      break;
    case MP_MODE_SINGLE:
      player.setPlayMode(PM_REPEAT_ONE);
      break;
    }
  }
  player.play();
}
