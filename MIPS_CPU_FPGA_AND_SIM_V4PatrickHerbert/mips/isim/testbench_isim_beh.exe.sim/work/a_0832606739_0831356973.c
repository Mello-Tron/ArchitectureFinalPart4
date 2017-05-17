/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/pherbert17/Documents/GitHub/ArchitectureFinalPart4/MIPS_CPU_FPGA_AND_SIM_V4PatrickHerbert/mips_alu.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

char *ieee_p_2592010699_sub_1697423399_503743352(char *, char *, char *, char *, char *, char *);
char *ieee_p_2592010699_sub_1735675855_503743352(char *, char *, char *, char *, char *, char *);
char *ieee_p_2592010699_sub_1837678034_503743352(char *, char *, char *, char *);
char *ieee_p_2592010699_sub_795620321_503743352(char *, char *, char *, char *, char *, char *);
unsigned char ieee_p_3620187407_sub_4042748798_3965413181(char *, char *, char *, char *, char *);
char *ieee_p_3620187407_sub_674691591_3965413181(char *, char *, char *, char *, unsigned char );
char *ieee_p_3620187407_sub_767668596_3965413181(char *, char *, char *, char *, char *, char *);


static void work_a_0832606739_0831356973_p_0(char *t0)
{
    char t9[16];
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    unsigned char t8;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;

LAB0:    xsi_set_current_line(29, ng0);
    t1 = (t0 + 1352U);
    t2 = *((char **)t1);
    t3 = (4 - 4);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t7 == (unsigned char)3);
    if (t8 != 0)
        goto LAB3;

LAB4:
LAB7:    t22 = (t0 + 1192U);
    t23 = *((char **)t22);
    t22 = (t0 + 5672);
    t24 = (t22 + 56U);
    t25 = *((char **)t24);
    t26 = (t25 + 56U);
    t27 = *((char **)t26);
    memcpy(t27, t23, 32U);
    xsi_driver_first_trans_fast(t22);

LAB2:    t28 = (t0 + 5512);
    *((int *)t28) = 1;

LAB1:    return;
LAB3:    t10 = (t0 + 1192U);
    t11 = *((char **)t10);
    t10 = (t0 + 10028U);
    t12 = ieee_p_2592010699_sub_1837678034_503743352(IEEE_P_2592010699, t9, t11, t10);
    t13 = (t9 + 12U);
    t14 = *((unsigned int *)t13);
    t15 = (1U * t14);
    t16 = (32U != t15);
    if (t16 == 1)
        goto LAB5;

LAB6:    t17 = (t0 + 5672);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    memcpy(t21, t12, 32U);
    xsi_driver_first_trans_fast(t17);
    goto LAB2;

LAB5:    xsi_size_not_matching(32U, t15, 0);
    goto LAB6;

LAB8:    goto LAB2;

}

static void work_a_0832606739_0831356973_p_1(char *t0)
{
    char t1[16];
    char t2[16];
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned char t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned char t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;

LAB0:    xsi_set_current_line(30, ng0);

LAB3:    t3 = (t0 + 1032U);
    t4 = *((char **)t3);
    t3 = (t0 + 10012U);
    t5 = (t0 + 1992U);
    t6 = *((char **)t5);
    t5 = (t0 + 10092U);
    t7 = ieee_p_3620187407_sub_767668596_3965413181(IEEE_P_3620187407, t2, t4, t3, t6, t5);
    t8 = (t0 + 1352U);
    t9 = *((char **)t8);
    t10 = (4 - 4);
    t11 = (t10 * -1);
    t12 = (1U * t11);
    t13 = (0 + t12);
    t8 = (t9 + t13);
    t14 = *((unsigned char *)t8);
    t15 = ieee_p_3620187407_sub_674691591_3965413181(IEEE_P_3620187407, t1, t7, t2, t14);
    t16 = (t1 + 12U);
    t17 = *((unsigned int *)t16);
    t18 = (1U * t17);
    t19 = (32U != t18);
    if (t19 == 1)
        goto LAB5;

LAB6:    t20 = (t0 + 5736);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    memcpy(t24, t15, 32U);
    xsi_driver_first_trans_fast(t20);

LAB2:    t25 = (t0 + 5528);
    *((int *)t25) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(32U, t18, 0);
    goto LAB6;

}

static void work_a_0832606739_0831356973_p_2(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;

LAB0:    xsi_set_current_line(32, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t3 = (31 - 31);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t7 == (unsigned char)3);
    if (t8 != 0)
        goto LAB3;

LAB4:
LAB5:    t16 = (t0 + 10414);
    t18 = (t0 + 5800);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    memcpy(t22, t16, 32U);
    xsi_driver_first_trans_fast(t18);

LAB2:    t23 = (t0 + 5544);
    *((int *)t23) = 1;

LAB1:    return;
LAB3:    t9 = (t0 + 10382);
    t11 = (t0 + 5800);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t9, 32U);
    xsi_driver_first_trans_fast(t11);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_0832606739_0831356973_p_3(char *t0)
{
    char t14[16];
    unsigned char t1;
    char *t2;
    char *t3;
    int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t15;
    char *t16;
    int t17;
    unsigned int t18;
    unsigned char t19;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;

LAB0:    xsi_set_current_line(33, ng0);
    t2 = (t0 + 2152U);
    t3 = *((char **)t2);
    t4 = (31 - 31);
    t5 = (t4 * -1);
    t6 = (1U * t5);
    t7 = (0 + t6);
    t2 = (t3 + t7);
    t8 = *((unsigned char *)t2);
    t9 = (t8 == (unsigned char)2);
    if (t9 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB8:    t26 = (t0 + 10510);
    t28 = (t0 + 5864);
    t29 = (t28 + 56U);
    t30 = *((char **)t29);
    t31 = (t30 + 56U);
    t32 = *((char **)t31);
    memcpy(t32, t26, 32U);
    xsi_driver_first_trans_fast(t28);

LAB2:    t33 = (t0 + 5560);
    *((int *)t33) = 1;

LAB1:    return;
LAB3:    t16 = (t0 + 10478);
    t21 = (t0 + 5864);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    memcpy(t25, t16, 32U);
    xsi_driver_first_trans_fast(t21);
    goto LAB2;

LAB5:    t10 = (t0 + 2152U);
    t11 = *((char **)t10);
    t10 = (t0 + 10092U);
    t12 = (t0 + 10446);
    t15 = (t14 + 0U);
    t16 = (t15 + 0U);
    *((int *)t16) = 0;
    t16 = (t15 + 4U);
    *((int *)t16) = 31;
    t16 = (t15 + 8U);
    *((int *)t16) = 1;
    t17 = (31 - 0);
    t18 = (t17 * 1);
    t18 = (t18 + 1);
    t16 = (t15 + 12U);
    *((unsigned int *)t16) = t18;
    t19 = ieee_p_3620187407_sub_4042748798_3965413181(IEEE_P_3620187407, t11, t10, t12, t14);
    t1 = t19;
    goto LAB7;

LAB9:    goto LAB2;

}

static void work_a_0832606739_0831356973_p_4(char *t0)
{
    char t31[16];
    char t46[16];
    char *t1;
    char *t2;
    char *t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    char *t7;
    char *t8;
    int t9;
    char *t10;
    char *t11;
    int t12;
    char *t13;
    char *t14;
    int t15;
    char *t16;
    char *t17;
    int t18;
    char *t19;
    char *t20;
    int t21;
    char *t22;
    int t24;
    char *t25;
    int t27;
    char *t28;
    int t30;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    unsigned char t40;
    char *t41;
    char *t42;
    char *t43;
    char *t44;
    char *t45;

LAB0:    t1 = (t0 + 4944U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(34, ng0);
    t2 = (t0 + 1352U);
    t3 = *((char **)t2);
    t4 = (4 - 3);
    t5 = (t4 * 1U);
    t6 = (0 + t5);
    t2 = (t3 + t6);
    t7 = (t0 + 10542);
    t9 = xsi_mem_cmp(t7, t2, 4U);
    if (t9 == 1)
        goto LAB5;

LAB14:    t10 = (t0 + 10546);
    t12 = xsi_mem_cmp(t10, t2, 4U);
    if (t12 == 1)
        goto LAB6;

LAB15:    t13 = (t0 + 10550);
    t15 = xsi_mem_cmp(t13, t2, 4U);
    if (t15 == 1)
        goto LAB7;

LAB16:    t16 = (t0 + 10554);
    t18 = xsi_mem_cmp(t16, t2, 4U);
    if (t18 == 1)
        goto LAB8;

LAB17:    t19 = (t0 + 10558);
    t21 = xsi_mem_cmp(t19, t2, 4U);
    if (t21 == 1)
        goto LAB9;

LAB18:    t22 = (t0 + 10562);
    t24 = xsi_mem_cmp(t22, t2, 4U);
    if (t24 == 1)
        goto LAB10;

LAB19:    t25 = (t0 + 10566);
    t27 = xsi_mem_cmp(t25, t2, 4U);
    if (t27 == 1)
        goto LAB11;

LAB20:    t28 = (t0 + 10570);
    t30 = xsi_mem_cmp(t28, t2, 4U);
    if (t30 == 1)
        goto LAB12;

LAB21:
LAB13:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 2312U);
    t3 = *((char **)t2);
    t2 = (t0 + 5928);
    t7 = (t2 + 56U);
    t8 = *((char **)t7);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 32U);
    xsi_driver_first_trans_fast_port(t2);

LAB4:    xsi_set_current_line(34, ng0);

LAB33:    t2 = (t0 + 5576);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB34;

LAB1:    return;
LAB5:    xsi_set_current_line(35, ng0);
    t32 = (t0 + 1032U);
    t33 = *((char **)t32);
    t32 = (t0 + 10012U);
    t34 = (t0 + 1192U);
    t35 = *((char **)t34);
    t34 = (t0 + 10028U);
    t36 = ieee_p_2592010699_sub_795620321_503743352(IEEE_P_2592010699, t31, t33, t32, t35, t34);
    t37 = (t31 + 12U);
    t38 = *((unsigned int *)t37);
    t39 = (1U * t38);
    t40 = (32U != t39);
    if (t40 == 1)
        goto LAB23;

LAB24:    t41 = (t0 + 5928);
    t42 = (t41 + 56U);
    t43 = *((char **)t42);
    t44 = (t43 + 56U);
    t45 = *((char **)t44);
    memcpy(t45, t36, 32U);
    xsi_driver_first_trans_fast_port(t41);
    goto LAB4;

LAB6:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 1032U);
    t3 = *((char **)t2);
    t2 = (t0 + 10012U);
    t7 = (t0 + 1192U);
    t8 = *((char **)t7);
    t7 = (t0 + 10028U);
    t10 = ieee_p_2592010699_sub_795620321_503743352(IEEE_P_2592010699, t46, t3, t2, t8, t7);
    t11 = ieee_p_2592010699_sub_1837678034_503743352(IEEE_P_2592010699, t31, t10, t46);
    t13 = (t31 + 12U);
    t4 = *((unsigned int *)t13);
    t5 = (1U * t4);
    t40 = (32U != t5);
    if (t40 == 1)
        goto LAB25;

LAB26:    t14 = (t0 + 5928);
    t16 = (t14 + 56U);
    t17 = *((char **)t16);
    t19 = (t17 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t11, 32U);
    xsi_driver_first_trans_fast_port(t14);
    goto LAB4;

LAB7:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 1032U);
    t3 = *((char **)t2);
    t2 = (t0 + 10012U);
    t7 = (t0 + 1192U);
    t8 = *((char **)t7);
    t7 = (t0 + 10028U);
    t10 = ieee_p_2592010699_sub_1735675855_503743352(IEEE_P_2592010699, t31, t3, t2, t8, t7);
    t11 = (t31 + 12U);
    t4 = *((unsigned int *)t11);
    t5 = (1U * t4);
    t40 = (32U != t5);
    if (t40 == 1)
        goto LAB27;

LAB28:    t13 = (t0 + 5928);
    t14 = (t13 + 56U);
    t16 = *((char **)t14);
    t17 = (t16 + 56U);
    t19 = *((char **)t17);
    memcpy(t19, t10, 32U);
    xsi_driver_first_trans_fast_port(t13);
    goto LAB4;

LAB8:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 2632U);
    t3 = *((char **)t2);
    t2 = (t0 + 5928);
    t7 = (t2 + 56U);
    t8 = *((char **)t7);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 32U);
    xsi_driver_first_trans_fast_port(t2);
    goto LAB4;

LAB9:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 2152U);
    t3 = *((char **)t2);
    t2 = (t0 + 5928);
    t7 = (t2 + 56U);
    t8 = *((char **)t7);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 32U);
    xsi_driver_first_trans_fast_port(t2);
    goto LAB4;

LAB10:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 1032U);
    t3 = *((char **)t2);
    t2 = (t0 + 10012U);
    t7 = (t0 + 1192U);
    t8 = *((char **)t7);
    t7 = (t0 + 10028U);
    t10 = ieee_p_2592010699_sub_1697423399_503743352(IEEE_P_2592010699, t31, t3, t2, t8, t7);
    t11 = (t31 + 12U);
    t4 = *((unsigned int *)t11);
    t5 = (1U * t4);
    t40 = (32U != t5);
    if (t40 == 1)
        goto LAB29;

LAB30:    t13 = (t0 + 5928);
    t14 = (t13 + 56U);
    t16 = *((char **)t14);
    t17 = (t16 + 56U);
    t19 = *((char **)t17);
    memcpy(t19, t10, 32U);
    xsi_driver_first_trans_fast_port(t13);
    goto LAB4;

LAB11:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 2792U);
    t3 = *((char **)t2);
    t2 = (t0 + 5928);
    t7 = (t2 + 56U);
    t8 = *((char **)t7);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 32U);
    xsi_driver_first_trans_fast_port(t2);
    goto LAB4;

LAB12:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 2472U);
    t3 = *((char **)t2);
    t2 = (t0 + 5928);
    t7 = (t2 + 56U);
    t8 = *((char **)t7);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 32U);
    xsi_driver_first_trans_fast_port(t2);
    goto LAB4;

LAB22:;
LAB23:    xsi_size_not_matching(32U, t39, 0);
    goto LAB24;

LAB25:    xsi_size_not_matching(32U, t5, 0);
    goto LAB26;

LAB27:    xsi_size_not_matching(32U, t5, 0);
    goto LAB28;

LAB29:    xsi_size_not_matching(32U, t5, 0);
    goto LAB30;

LAB31:    t3 = (t0 + 5576);
    *((int *)t3) = 0;
    goto LAB2;

LAB32:    goto LAB31;

LAB34:    goto LAB32;

}

static void work_a_0832606739_0831356973_p_5(char *t0)
{
    char t5[16];
    char *t1;
    char *t2;
    char *t3;
    char *t6;
    char *t7;
    int t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;

LAB0:    xsi_set_current_line(44, ng0);
    t1 = (t0 + 1672U);
    t2 = *((char **)t1);
    t1 = (t0 + 10076U);
    t3 = (t0 + 10574);
    t6 = (t5 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 31;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t8 = (31 - 0);
    t9 = (t8 * 1);
    t9 = (t9 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t9;
    t10 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t3, t5);
    if (t10 != 0)
        goto LAB3;

LAB4:
LAB5:    t15 = (t0 + 5992);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    *((unsigned char *)t19) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t15);

LAB2:    t20 = (t0 + 5592);
    *((int *)t20) = 1;

LAB1:    return;
LAB3:    t7 = (t0 + 5992);
    t11 = (t7 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t7);
    goto LAB2;

LAB6:    goto LAB2;

}


extern void work_a_0832606739_0831356973_init()
{
	static char *pe[] = {(void *)work_a_0832606739_0831356973_p_0,(void *)work_a_0832606739_0831356973_p_1,(void *)work_a_0832606739_0831356973_p_2,(void *)work_a_0832606739_0831356973_p_3,(void *)work_a_0832606739_0831356973_p_4,(void *)work_a_0832606739_0831356973_p_5};
	xsi_register_didat("work_a_0832606739_0831356973", "isim/testbench_isim_beh.exe.sim/work/a_0832606739_0831356973.didat");
	xsi_register_executes(pe);
}
