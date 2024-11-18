// /chess/Main.qml
#include <QtQml/qqmlprivate.h>
#include <QtCore/qdatetime.h>
#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtCore/qstringlist.h>
#include <QtCore/qurl.h>
#include <QtCore/qvariant.h>
#include <QtQml/qjsengine.h>
#include <QtQml/qjsprimitivevalue.h>
#include <QtQml/qjsvalue.h>
#include <QtQml/qqmlcomponent.h>
#include <QtQml/qqmlcontext.h>
#include <QtQml/qqmlengine.h>
#include <type_traits>
namespace QmlCacheGeneratedCode {
namespace _chess_Main_qml {
extern const unsigned char qmlData alignas(16) [] = {

0x71,0x76,0x34,0x63,0x64,0x61,0x74,0x61,
0x34,0x0,0x0,0x0,0x2,0x3,0x6,0x0,
0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0xc8,0x2,0x0,0x0,0x65,0x66,0x36,0x35,
0x65,0x66,0x30,0x66,0x31,0x63,0x30,0x63,
0x36,0x64,0x39,0x63,0x32,0x36,0x33,0x35,
0x30,0x37,0x32,0x33,0x33,0x64,0x61,0x62,
0x64,0x64,0x39,0x62,0x61,0x32,0x65,0x35,
0x35,0x39,0x32,0x33,0x0,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0xbf,0x58,0x89,0x66,
0x7e,0x48,0x4c,0xd2,0xe2,0x1e,0x10,0x82,
0x1f,0x85,0x7c,0xfd,0x0,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x23,0x0,0x0,0x0,
0x8,0x0,0x0,0x0,0x20,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0xf8,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0xf8,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0xf8,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0xf8,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0xf8,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0xf8,0x0,0x0,0x0,
0x2,0x0,0x0,0x0,0x0,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0x10,0x1,0x0,0x0,
0x1,0x0,0x0,0x0,0x10,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0x20,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0x20,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0x20,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0x20,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0x20,0x1,0x0,0x0,
0xff,0xff,0xff,0xff,0x0,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0xe8,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x0,0x0,0x78,0xbf,
0x0,0x0,0x0,0x0,0x0,0x0,0x82,0xbf,
0x7,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0xff,0xff,0xff,0xff,0x0,0x0,0x0,0x0,
0x40,0x1,0x0,0x0,0x48,0x1,0x0,0x0,
0x60,0x1,0x0,0x0,0x78,0x1,0x0,0x0,
0x88,0x1,0x0,0x0,0xa0,0x1,0x0,0x0,
0xb8,0x1,0x0,0x0,0xc8,0x1,0x0,0x0,
0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x7,0x0,0x0,0x0,0x51,0x0,0x74,0x0,
0x51,0x0,0x75,0x0,0x69,0x0,0x63,0x0,
0x6b,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x6,0x0,0x0,0x0,0x57,0x0,0x69,0x0,
0x6e,0x0,0x64,0x0,0x6f,0x0,0x77,0x0,
0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x5,0x0,0x0,0x0,0x77,0x0,0x69,0x0,
0x64,0x0,0x74,0x0,0x68,0x0,0x0,0x0,
0x6,0x0,0x0,0x0,0x68,0x0,0x65,0x0,
0x69,0x0,0x67,0x0,0x68,0x0,0x74,0x0,
0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x7,0x0,0x0,0x0,0x76,0x0,0x69,0x0,
0x73,0x0,0x69,0x0,0x62,0x0,0x6c,0x0,
0x65,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x5,0x0,0x0,0x0,0x74,0x0,0x69,0x0,
0x74,0x0,0x6c,0x0,0x65,0x0,0x0,0x0,
0xb,0x0,0x0,0x0,0x48,0x0,0x65,0x0,
0x6c,0x0,0x6c,0x0,0x6f,0x0,0x20,0x0,
0x57,0x0,0x6f,0x0,0x72,0x0,0x6c,0x0,
0x64,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x1,0x0,0x0,0x0,0x10,0x0,0x0,0x0,
0x1,0x0,0x0,0x0,0x24,0x0,0x0,0x0,
0x1,0x0,0x0,0x0,0x1,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x1,0x0,0x10,0x0,
0xff,0xff,0x0,0x0,0x28,0x0,0x0,0x0,
0x2,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0x0,0x0,0xff,0xff,0xff,0xff,0xff,0xff,
0x0,0x0,0x0,0x0,0x54,0x0,0x0,0x0,
0x54,0x0,0x0,0x0,0x54,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x54,0x0,0x0,0x0,
0x54,0x0,0x0,0x0,0x0,0x0,0x4,0x0,
0x54,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
0xb4,0x0,0x0,0x0,0x3,0x0,0x10,0x0,
0x0,0x0,0x0,0x0,0xb4,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0xb4,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x6,0x0,0x0,0x0,
0x0,0x0,0x5,0x0,0x0,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x7,0x0,0x50,0x0,
0x7,0x0,0xc0,0x0,0x5,0x0,0x0,0x0,
0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x6,0x0,0x50,0x0,
0x6,0x0,0xe0,0x0,0x4,0x0,0x0,0x0,
0x0,0x0,0x2,0x0,0x1,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x5,0x0,0x50,0x0,
0x5,0x0,0xd0,0x0,0x3,0x0,0x0,0x0,
0x0,0x0,0x2,0x0,0x0,0x0,0x0,0x0,
0x0,0x0,0x0,0x0,0x4,0x0,0x50,0x0,
0x4,0x0,0xc0,0x0,0x0,0x0,0x0,0x0
};
QT_WARNING_PUSH
QT_WARNING_DISABLE_MSVC(4573)
extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[] = { { 0, QMetaType::fromType<void>(), {}, nullptr } };QT_WARNING_POP
}
}
