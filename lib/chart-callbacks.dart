
 import 'package:fliechart/slice-descriptor.dart';

abstract class IPieChartCallbacks {

  void tappedSlice(ISliceDescriptor slice);
}

class PieChartCallbacks extends IPieChartCallbacks {

   final void Function(ISliceDescriptor) _tappedSlice;

   PieChartCallbacks({ Function(ISliceDescriptor) tappedSlice}) : this._tappedSlice = tappedSlice;

   @override
   void tappedSlice(ISliceDescriptor slice) {
     if (_tappedSlice != null) _tappedSlice(slice);
   }
}