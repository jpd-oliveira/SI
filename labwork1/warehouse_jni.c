#include<jni.h>
#include<warehouse.h>

/*
 * Class:     si_fct_unl_Warehouse
 * Method:    initilizeHardwarePorts
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_initilizeHardwarePorts(JNIEnv* env, jobject obj) {

	initializeHardwarePorts();
}

/*
 * Class:     si_fct_unl_Warehouse
 * Method:    getXPosition
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_si_fct_unl_Warehouse_getXPosition(JNIEnv* env, jobject obj) {

	return getXPosition();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    getYPosition
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_si_fct_unl_Warehouse_getYPosition(JNIEnv* env, jobject obj) {

	return getYPosition();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    getZPosition
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_si_fct_unl_Warehouse_getZPosition(JNIEnv* env, jobject obj) {

	return getZPosition();

}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    getXMoving
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_si_fct_unl_Warehouse_getXMoving(JNIEnv* env, jobject obj) {

	return getXMoving();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    getYMoving
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_si_fct_unl_Warehouse_getYMoving(JNIEnv* env, jobject obj) {

	return getYMoving();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    getZMoving
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_si_fct_unl_Warehouse_getZMoving(JNIEnv* env, jobject obj) {

	return getZMoving();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    getLeftStationMoving
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_si_fct_unl_Warehouse_getLeftStationMoving(JNIEnv* env, jobject obj) {

	return getLeftStationMoving();

}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    getRightStationMoving
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_si_fct_unl_Warehouse_getRightStationMoving(JNIEnv* env, jobject obj) {

	return getRightStationMoving();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    isAtZUp
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_si_fct_unl_Warehouse_isAtZUp(JNIEnv* env, jobject obj) {

	return isAtZUp();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    isAtZDown
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_si_fct_unl_Warehouse_isAtZDown(JNIEnv* env, jobject obj) {

	return isAtZDown();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    isPartInCage
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_si_fct_unl_Warehouse_isPartInCage(JNIEnv* env, jobject obj) {

	return isPartInCage();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    isPartOnLeftStation
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_si_fct_unl_Warehouse_isPartOnLeftStation(JNIEnv* env, jobject obj) {

	return isPartOnLeftStation();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    isPartOnRightStation
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_si_fct_unl_Warehouse_isPartOnRightStation(JNIEnv* env, jobject obj) {

	return isPartOnRightStation();

}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveXRight
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveXRight(JNIEnv* env, jobject obj) {

	 moveXRight();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveXLeft
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveXLeft(JNIEnv* env, jobject obj) {

	moveXLeft();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    stopX
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_stopX(JNIEnv* env, jobject obj) {

	stopX();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveYInside
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveYInside(JNIEnv* env, jobject obj) {

	moveYInside();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveYoutside
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveYoutside(JNIEnv* env, jobject obj) {

	moveYOutside();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    stopY
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_stopY(JNIEnv* env, jobject obj) {

	stopY();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveZUp
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveZUp(JNIEnv* env, jobject obj) {

	moveZUp();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveZDown
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveZDown(JNIEnv* env, jobject obj) {

	moveZDown();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    stopZ
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_stopZ(JNIEnv* env, jobject obj) {

	stopZ();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveLeftStationInside
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveLeftStationInside(JNIEnv* env, jobject obj) {

	moveLeftStationInside();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveLeftStationOutside
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveLeftStationOutside(JNIEnv* env, jobject obj) {

	moveLeftStationOutside();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    stopLeftStation
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_stopLeftStation(JNIEnv* env, jobject obj) {

	stopLeftStation();

}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveRightStationInside
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveRightStationInside(JNIEnv* env, jobject obj) {

	moveRightStationInside();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    moveRightStationOutside
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_moveRightStationOutside(JNIEnv* env, jobject obj) {

	moveRightStationOutside();
}


/*
 * Class:     si_fct_unl_Warehouse
 * Method:    stopRightStation
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_si_fct_unl_Warehouse_stopRightStation(JNIEnv* env, jobject obj) {

	stopRightStation();

}
