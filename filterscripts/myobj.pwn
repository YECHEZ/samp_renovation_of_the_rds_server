//==============================================================================
//                            �������� ���������
//==============================================================================

#define MOD77INS 1 //��������� ������������� ����������:
//                 //MOD77INS 0 - ��� ������������� ����������.
//                 //MOD77INS 1 - � �������������� ����������.

#define MOD88INS 1 //��������� ������������� 3D-�������:
//                 //MOD77INS 0 - ��� ������������� 3D-�������.
//                 //MOD77INS 1 - � �������������� 3D-�������.

//   �������� !!! ����� ��������� �������� ����������� ��������������� !!!
//==============================================================================

//   �������� !!! ��� ��������� ����� ������ ������ �� ����������� ������� !!!
//   �� �������� �� [Gn_R] ��� ��������� ������ �� ����� !!!
//   ���� � ���� ���� �������� ������ ����������, �� ����� ���������
//   ������ ���������� (� ����) ���������� �������� ������:

//		new carplay = GetPlayerVehicleID(playerid);
//		if(CallRemoteFunction("myobjvehfunc", "d", carplay) != 0)//������ �� ���������� �� ������� myobj
//		{
//			SendClientMessage(playerid, 0xFF0000FF, " ������ ! ��� �������� ��������� ��������� !");
//			return 1;
//		}

//   ��� �� ��������� ����������� �������� ���������� �� ������� myobj !!!

//==============================================================================

//==============================================================================

#if (MOD77INS < 0)
	#undef MOD77INS
	#define MOD77INS 0
#endif
#if (MOD77INS > 1)
	#undef MOD77INS
	#define MOD77INS 1
#endif
#if (MOD88INS < 0)
	#undef MOD88INS
	#define MOD88INS 0
#endif
#if (MOD88INS > 1)
	#undef MOD88INS
	#define MOD88INS 1
#endif

#include <a_samp>
#include <streamer>

#if (MOD77INS == 1)
	#define MAXVEH 3 //����� ������ ���������� (����������� - ������ ���������� !!!)
	new objveh[MAXVEH];//������ �� ����������
#endif
#if (MOD88INS == 1)
	#define MAX3DT 3 //����� 3D-������� (����������� - ������ ���������� !!!)
	new Text3D:obj3dt[MAX3DT];//������ �� 3D-�������
#endif

forward myobjtime();

new Text3D:fantxt;//���������� ��� �������� 3D-������ � ������������� ��

public OnFilterScriptInit()
{
	fantxt = Create3DTextLabel(" ",0xFFFFFFAA,0.000,0.000,-4.000,18.0,0,1);//������ 3D-����� � ������������� ��
	SetTimer("myobjtime", 1500, 0);
	return 1;
}

public OnFilterScriptExit()
{
	Delete3DTextLabel(fantxt);//������� 3D-����� � ������������� ��
#if (MOD77INS == 1)
	for(new i = 0; i < MAXVEH; i++)
	{
		DestroyVehicle(objveh[i]);
	}
#endif
#if (MOD88INS == 1)
	for(new i = 0; i < MAX3DT; i++)
	{
		DestroyDynamic3DTextLabel(obj3dt[i]);
	}
#endif
	return 1;
}

public myobjtime()
{
//	���� ������ �������

//	����������� ������� �������� ���-������������� (�� ����� ���������� � ������������ ������� !!!)
//	CreateObject(988, 2508.16699, -1677.91479, 13.56860,   0.00000, 0.00000, -120.00000);
//	CreateObject(988, 2510.76660, -1670.00928, 13.45860,   0.00000, 0.00000, -91.00000);
//	CreateObject(988, 2509.57983, -1662.63647, 13.59860,   0.00000, 0.00000, -62.00000);

//	������������ �������
	CreateDynamicObject(988, 2508.16699, -1677.91479, 13.56860,   0.00000, 0.00000, -120.00000, -1, -1, -1, 300);
	CreateDynamicObject(988, 2510.76660, -1670.00928, 13.45860,   0.00000, 0.00000, -91.00000, -1, -1, -1, 300);
	CreateDynamicObject(988, 2509.57983, -1662.63647, 13.59860,   0.00000, 0.00000, -62.00000, -1, -1, -1, 300);

#if (MOD77INS == 1)
//  ���������
	objveh[0] = CreateVehicle(562, 2510.58, -1679.28, 13.21, 330.32, 1, 1, 90000);
	objveh[1] = CreateVehicle(562, 2513.33, -1669.96, 13.20, 358.81, 1, 1, 90000);
	objveh[2] = CreateVehicle(562, 2511.63, -1661.40, 13.25, 29.08, 1, 1, 90000);
#endif

#if (MOD88INS == 1)
//	3D-������
	obj3dt[0] = CreateDynamic3DTextLabel("�����1", 0xFF0000FF, 2492.34, -1666.33, 13.34, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1);
	obj3dt[1] = CreateDynamic3DTextLabel("�����2", 0x00FF00FF, 2490.34, -1666.33, 13.34, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1);
	obj3dt[2] = CreateDynamic3DTextLabel("�����3", 0x0000FFFF, 2488.34, -1666.33, 13.34, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1);
#endif

	return 1;
}

#if (MOD77INS == 1)
	forward myobjvehfunc(carid);
	public myobjvehfunc(carid)
	{
		new para1 = 0;
		for(new i; i < MAXVEH; i++)
		{
			if(objveh[i] == carid)//���� �� ���������� ���������� ���� � ������� myobj, ��:
			{
				para1 = 1;//���������� 1 (�����, ���������� 0)
			}
		}
	    return para1;
	}
#endif

