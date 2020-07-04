//==============================================================================
//             Мод портирования базы данных аккаунтов игроков

// Исходная база данных должна быть расположена в каталоге scriptfiles\.
// Имя файла исходной базы данных (БЕЗ типа (расширения) файла) нужно
// задать в строке 37. Полный путь базы данных: scriptfiles\players1.db
// Портированная база данных должна быть расположена в каталоге scriptfiles\.
// Имя файла портированной базы данных (БЕЗ типа (расширения) файла) нужно
// задать в строке 38. Полный путь базы данных: scriptfiles\players2.db
// Инструкции по портированию читайте в комментариях мода.

//==============================================================================

#include <a_samp>

#pragma dynamic 30000

new DB:player1db;//переменная исходной базы данных аккаунтов игроков
new DB:player2db;//переменная портированной базы данных аккаунтов игроков
new DBResult:query1db;//переменная запросов исходной базы данных аккаунтов игроков
new Name1[32];//имя файла исходной БД (в каталоге scriptfiles)
new Name2[32];//имя файла портированной БД (в каталоге scriptfiles)
new datad[100];//массив целочисленных переменных
new Float:dataf[100];//массив вещественных переменных
new datas[100][256];//массив строковых переменных

main()
{
	print(" ");
	print("\n------------------------------------------------");
	print(" Мод портирования базы данных аккаунтов игроков   ");
	print("------------------------------------------------\n");
}

public OnGameModeInit()
{
	Name1 = "players1";//имя файла исходной БД (в каталоге scriptfiles)
	Name2 = "players2";//имя файла портированной БД (в каталоге scriptfiles)
	SetTimer("Begin", 500, 0);
	return 1;
}

public OnGameModeExit()
{
	db_close(player1db);//отключаем исходную БД от сервера
	db_close(player2db);//отключаем портированную БД от сервера
	return 1;
}

forward Begin();
public Begin()
{
	new string[256];
	format(string, sizeof(string), "%s.db", Name1);
	if(!fexist(string))
	{
		print(" ");
		print(" Ошибка ! Исходная база данных не обнаружена !");
		return 1;
	}
	format(string, sizeof(string), "%s.db", Name2);
	if(fexist(string))
	{
		fremove(string);
	}
	print(" ");
	print(" Обнаружена исходная база данных.");
	SetTimer("Portation", 500, 0);
	return 1;
}

forward Portation();
public Portation()
{
	new string[256];
	format(string, sizeof(string), "%s.db", Name1);
	player1db = db_open(string);//подключаем исходную БД к серверу
	format(string, sizeof(string), "%s.db", Name2);
	player2db = db_open(string);//подключаем портированную БД к серверу

	//определение числа строк в исходной БД
	format(string, sizeof(string), "SELECT * FROM Players WHERE (IDCopy = 1)");//создаём запрос БД
	query1db = db_query(player1db, string);//отправляем запрос БД
	new para1;
	para1 = db_num_rows(query1db);//переведём результат запроса в число найденных строк в БД
	printf(" Число строк в исходной БД: %d", para1);

	//добавим три новых переменных, одну - целочисленную (Data1), одну - вещественную (Data2), и одну - строковую (Data3)
	//в аккаунты всех игроков, и присвоим этим переменным значения: Data1 = 10, Data2 = 100.378, Data3 = 'free' .
	//Три новые переменные расположим между числовой переменной (DEndConY) и строковой переменной (IPAdr)

	//создание новой (пустой) БД
	new ss01[256], ss02[256], ss03[256], ss04[256], ss05[256], ss00[1280];//создаём запрос БД
	format(ss01, 256, "CREATE TABLE Players(IDCopy INTEGER,Name VARCHAR(32),Key VARCHAR(32),TDReg VARCHAR(32),DEndConD INTEGER,");
	format(ss02, 256, "DEndConM INTEGER,DEndConY INTEGER,Data1 INTEGER,Data2 FLOAT,Data3 VARCHAR(32),IPAdr VARCHAR(32),MinLog INTEGER,AdminLevel INTEGER,AdminShadow INTEGER,");
	format(ss03, 256, "AdminLive INTEGER,AdminScanCom INTEGER,Registered INTEGER,Prison INTEGER,Prisonsec INTEGER,Muted INTEGER,");
	format(ss04, 256, "Mutedsec INTEGER,Money INTEGER,Kills INTEGER,Deaths INTEGER,Police INTEGER,Deport INTEGER,RecPM INTEGER,");
	format(ss05, 256, "Wanted INTEGER,Lock INTEGER,Gang INTEGER,GangLvl INTEGER)");
	format(ss00, 1280, "%s%s%s%s%s", ss01, ss02, ss03, ss04, ss05);
	db_query(player2db, ss00);//отправляем запрос на создание новой (пустой) БД

	//создание новых переменных (Data1, Data2, Data3)
	datad[70] = 10;//Data1
	dataf[80] = 100.378;//Data2
	strdel(datas[90], 0, 256);
	strins(datas[90], "free", 0, 256);//Data3

	//портирование БД
	new para2;
	para2 = para1 - 1;
	new para3 = 0;
	new para4 = 0;
	new buffer[32];
	new s01[256], s02[256], s03[256], s04[256], s05[256], s06[256], saa[1536];
	new s07[256], s08[256], s09[256], s10[256], s11[256], s12[256], sbb[1536];
	new s00[3072];
	print(" Начало портирования. Не отключайте (не закрывайте) мод !!!");
	for(new i = 0; i < para1; i++)
	{
		//чтение одной строки исходной БД
		db_get_field(query1db, 0, buffer, 32); datad[0] = strval(buffer);//IDCopy
		db_get_field(query1db, 1, datas[0], 256);//Name
		db_get_field(query1db, 2, datas[1], 256);//Key
		db_get_field(query1db, 3, datas[2], 256);//TDReg
		db_get_field(query1db, 4, buffer, 32); datad[1] = strval(buffer);//DEndConD
		db_get_field(query1db, 5, buffer, 32); datad[2] = strval(buffer);//DEndConM
		db_get_field(query1db, 6, buffer, 32); datad[3] = strval(buffer);//DEndConY
		db_get_field(query1db, 7, datas[3], 256);//IPAdr
		db_get_field(query1db, 8, buffer, 32); datad[4] = strval(buffer);//MinLog
		db_get_field(query1db, 9, buffer, 32); datad[5] = strval(buffer);//AdminLevel
		db_get_field(query1db, 10, buffer, 32); datad[6] = strval(buffer);//AdminShadow
		db_get_field(query1db, 11, buffer, 32); datad[7] = strval(buffer);//AdminLive
		db_get_field(query1db, 12, buffer, 32); datad[8] = strval(buffer);//AdminScanCom
		db_get_field(query1db, 13, buffer, 32); datad[9] = strval(buffer);//Registered
		db_get_field(query1db, 14, buffer, 32); datad[10] = strval(buffer);//Prison
		db_get_field(query1db, 15, buffer, 32); datad[11] = strval(buffer);//Prisonsec
		db_get_field(query1db, 16, buffer, 32); datad[12] = strval(buffer);//Muted
		db_get_field(query1db, 17, buffer, 32); datad[13] = strval(buffer);//Mutedsec
		db_get_field(query1db, 18, buffer, 32); datad[14] = strval(buffer);//Money
		db_get_field(query1db, 19, buffer, 32); datad[15] = strval(buffer);//Kills
		db_get_field(query1db, 20, buffer, 32); datad[16] = strval(buffer);//Deaths
		db_get_field(query1db, 21, buffer, 32); datad[17] = strval(buffer);//Police
		db_get_field(query1db, 22, buffer, 32); datad[18] = strval(buffer);//Deport
		db_get_field(query1db, 23, buffer, 32); datad[19] = strval(buffer);//RecPM
		db_get_field(query1db, 24, buffer, 32); datad[20] = strval(buffer);//Wanted
		db_get_field(query1db, 25, buffer, 32); datad[21] = strval(buffer);//Lock
		db_get_field(query1db, 26, buffer, 32); datad[22] = strval(buffer);//Gang
		db_get_field(query1db, 27, buffer, 32); datad[23] = strval(buffer);//GangLvl
//		db_get_field(query1db, 28, buffer, 32); dataf[0] = floatstr(buffer);//вариант чтения вещественной переменной из БД

		//добавление одной строки в портированную БД
		format(s01, 256, "INSERT INTO Players (IDCopy,Name,Key,TDReg,DEndConD,DEndConM,DEndConY,Data1,Data2,Data3,IPAdr,MinLog,AdminLevel,");
		format(s02, 256, "AdminShadow,AdminLive,AdminScanCom,Registered,Prison,Prisonsec,Muted,Mutedsec,Money,Kills,Deaths,Police,");
		format(s03, 256, "Deport,RecPM,Wanted,Lock,Gang,GangLvl) ");
		format(s04, 256, "VALUES (%d,'%s','%s','%s',",datad[0],datas[0],datas[1],datas[2]);//IDCopy,Name,Key,TDReg
		format(s05, 256, "%d,%d,%d,%d,%f,'%s','%s',",datad[1],datad[2],datad[3],datad[70],dataf[80],datas[90],datas[3]);//DEndConD,DEndConM,DEndConY,Data1,Data2,Data3,IPAdr
		format(s06, 256, "%d,%d,%d,",datad[4],datad[5],datad[6]);//MinLog,AdminLevel,AdminShadow
		format(s07, 256, "%d,%d,%d,",datad[7],datad[8],datad[9]);//AdminLive,AdminScanCom,Registered
		format(s08, 256, "%d,%d,%d,",datad[10],datad[11],datad[12]);//Prison,Prisonsec,Muted
		format(s09, 256, "%d,%d,%d,",datad[13],datad[14],datad[15]);//Mutedsec,Money,Kills
		format(s10, 256, "%d,%d,%d,",datad[16],datad[17],datad[18]);//Deaths,Police,Deport
		format(s11, 256, "%d,%d,%d,",datad[19],datad[20],datad[21]);//RecPM,Wanted,Lock
		format(s12, 256, "%d,%d)",datad[22],datad[23]);//Gang,GangLvl
		format(saa, 1536, "%s%s%s%s%s%s", s01, s02, s03, s04, s05, s06);
		format(sbb, 1536, "%s%s%s%s%s%s", s07, s08, s09, s10, s11, s12);
		format(s00, 3072, "%s%s", saa, sbb);
		db_query(player2db, s00);//отправляем запрос на добавление одной строки в портированную БД

		if(i != para2)//если была портирована НЕ последняя строка, то:
		{
			db_next_row(query1db);//переходим к следующей строке исходной БД
		}
		para3++;
		para4++;
		if(para4 >= 100)
		{
			para4 = 0;
			printf(" Портировано %d строк БД.", para3);

		}
	}
	db_free_result(query1db);//очищаем результат запроса БД
	print(" ");
	print(" Вся исходная БД портирована ! Можно отключить (закрыть) мод.");
	print(" ");
	db_close(player1db);//отключаем исходную БД от сервера
	db_close(player2db);//отключаем портированную БД от сервера
	return 1;
}

