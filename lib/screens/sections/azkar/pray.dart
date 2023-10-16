import 'package:calender_project/Custom_Widget/Buttons.dart';
import 'package:flutter/material.dart';
class PrayThiker extends StatefulWidget {
  const PrayThiker({Key? key}) : super(key: key);

  @override
  State<PrayThiker> createState() => _PrayThikerState();
}

class _PrayThikerState extends State<PrayThiker> {

  List zikr = [
   'أَسْـتَغْفِرُ الله، أَسْـتَغْفِرُ الله، أَسْـتَغْفِرُ الله، اللّهُـمَّ أَنْـتَ السَّلامُ ، وَمِـنْكَ السَّلام ، تَبارَكْتَ يا ذا الجَـلالِ وَالإِكْـرام',
    'لا إلهَ إلاّ اللّهُ وحدَهُ لا شريكَ لهُ، لهُ المُـلْكُ ولهُ الحَمْد، وهوَ على كلّ شَيءٍ قَدير، اللّهُـمَّ لا مانِعَ لِما أَعْطَـيْت، وَلا مُعْطِـيَ لِما مَنَـعْت، وَلا يَنْفَـعُ ذا الجَـدِّ مِنْـكَ الجَـد',
    'لا إلهَ إلاّ اللّه, وحدَهُ لا شريكَ لهُ، لهُ الملكُ ولهُ الحَمد، وهوَ على كلّ شيءٍ قدير، لا حَـوْلَ وَلا قـوَّةَ إِلاّ بِاللهِ، لا إلهَ إلاّ اللّـه، وَلا نَعْـبُـدُ إِلاّ إيّـاه, لَهُ النِّعْـمَةُ وَلَهُ الفَضْل وَلَهُ الثَّـناءُ الحَـسَن، لا إلهَ إلاّ اللّهُ مخْلِصـينَ لَـهُ الدِّينَ وَلَوْ كَـرِهَ الكـافِرون',
    'سُـبْحانَ اللهِ، والحَمْـدُ لله ، واللهُ أكْـبَر',
    'لا إلهَ إلاّ اللّهُ وَحْـدَهُ لا شريكَ لهُ، لهُ الملكُ ولهُ الحَمْد، وهُوَ على كُلّ شَيءٍ قَـدير',
    'قُلْ هُوَ ٱللَّهُ أَحَدٌ، ٱللَّهُ ٱلصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌۢ',
    'قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ، وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِى ٱلْعُقَدِ، وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
    'قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ، مَلِكِ ٱلنَّاسِ، إِلَٰهِ ٱلنَّاسِ، مِن شَرِّ ٱلْوَسْوَاسِ ٱلْخَنَّاسِ، ٱلَّذِى يُوَسْوِسُ فِى صُدُورِ ٱلنَّاسِ، مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ',
    'اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلاَّ بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
    'لا إلهَ إلاّ اللّهُ وحْـدَهُ لا شريكَ لهُ، لهُ المُلكُ ولهُ الحَمْد، يُحيـي وَيُمـيتُ وهُوَ على كُلّ شيءٍ قدير',
    'اللّهُـمَّ إِنِّـي أَسْأَلُـكَ عِلْمـاً نافِعـاً وَرِزْقـاً طَيِّـباً ، وَعَمَـلاً مُتَقَـبَّلاً',
    'اللَّهُمَّ أَجِرْنِي مِنْ النَّار',
    'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
  ];
  List counter = [
    1, 1, 1, 33, 1, 3, 3, 3, 1, 10, 1, 7, 1,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: const IconThemeData(color: Color.fromRGBO(215, 190, 105, 1),size: 30),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  counter = [
                    1, 1, 1, 33, 1, 3, 3, 3, 1, 10, 1, 7, 1,
                  ];
                });
              },
              icon: Icon(Icons.restart_alt)),
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              color: Color.fromRGBO(215, 190, 105, 1),
            ),
            color: Theme.of(context).backgroundColor,
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined,size: 20,),
                    const SizedBox(width:10),
                    const Text("Settings"),
                  ],
                ),
              ),
            ],
            onSelected: (value) async{
              switch (value) {
                case 1:
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.89,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: zikr.length,
                    itemBuilder: (BuildContext ctx,int i){
                      return Card(
                        color: Theme.of(context).backgroundColor,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                zikr[i],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.right,
                              ),
                              // subtitle: SizedBox(height: 20,)
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonAsText(
                                  onPressed: counter[i]!=0?
                                      (){
                                    if(counter[i]>=1 && counter[i]>0){
                                      setState(() {
                                        counter[i]--;
                                      });
                                      print(counter[i]);
                                    }
                                  }
                                      :null,
                                  text: counter[i].toString(),),
                              ],
                            ),
                            SizedBox(height: 5,)
                          ],
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
