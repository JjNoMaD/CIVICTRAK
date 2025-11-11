import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/complaint_repository.dart';
import '../data/complaint_model.dart';

class ComplaintListPage extends StatefulWidget { const ComplaintListPage({super.key}); @override State<ComplaintListPage> createState()=>_ComplaintListPageState();}
class _ComplaintListPageState extends State<ComplaintListPage>{
  List<Complaint>? items;
  @override void initState(){ super.initState(); _load(); }
  Future<void> _load() async { items = await ComplaintRepository().list(); if(mounted) setState((){}); }

  @override Widget build(BuildContext ctx)=>Scaffold(
    appBar: AppBar(title: const Text('Complaints')),
    floatingActionButton: FloatingActionButton(onPressed: ()=> ctx.push('/citizen/submit'), child: const Icon(Icons.add)),
    body: items==null? const Center(child:CircularProgressIndicator())
      : ListView.separated(itemCount: items!.length, separatorBuilder: (_, __)=> const Divider(),
        itemBuilder: (_, i){
          final c = items![i];
          return ListTile(
            title: Text('${c.category} — ${c.status}'),
            subtitle: Text(c.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            onTap: ()=> ctx.push('/detail/${c.id}'),
          );
        }),
  );
}
