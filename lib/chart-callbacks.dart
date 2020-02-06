
 import 'package:fliechart/slice-descriptor.dart';

abstract class IPieChartCallbacks {

  void tappedSlice(List<ISliceDescriptor> allSlices, ISliceDescriptor tappedSlice);
}

class PieChartCallbacks extends IPieChartCallbacks {

   final void Function(List<ISliceDescriptor>, ISliceDescriptor) _tappedSlice;

   PieChartCallbacks({ Function(List<ISliceDescriptor>, SliceDescriptor) tappedSlice}) : this._tappedSlice = tappedSlice;

   @override
   void tappedSlice(List<ISliceDescriptor> allSlices, ISliceDescriptor tappedSlice) {
     if (_tappedSlice != null) _tappedSlice(allSlices, tappedSlice);
   }
}