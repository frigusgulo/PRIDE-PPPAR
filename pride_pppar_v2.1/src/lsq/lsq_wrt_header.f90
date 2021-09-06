!
!! lsq_wrt_header.f90
!!
!!    Copyright (C) 2021 by Wuhan University
!!
!!    This program belongs to PRIDE PPP-AR which is an open source software:
!!    you can redistribute it and/or modify it under the terms of the GNU
!!    General Public License (version 3) as published by the Free Software Foundation.
!!
!!    This program is distributed in the hope that it will be useful,
!!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!!    GNU General Public License (version 3) for more details.
!!
!!    You should have received a copy of the GNU General Public License
!!    along with this program.  If not, see <https://www.gnu.org/licenses/>.
!!
!! Contributor: Jianghui Geng, Songfeng Yang
!! 
!!
!
subroutine lsq_wrt_header(lfn, LCF, SITE, OB, write_file, write_posseq, write_config, write_note, write_end)
  implicit none
  include '../header/const.h'
  include 'lsqcfg.h'
  include '../header/station.h'
  include '../header/rnxobs.h'

  type(lsqcfg) LCF
  type(station) SITE 
  type(rnxobr) OB
  integer*4 lfn, i, isat
  integer*4 iy, imon, id, ih, imin, idoy
  real*8 sec
  character*256 msg
  character*20 line1, line2, line3, line4, line5, line6
  character*60 line
  character*(*) write_file
  
  logical*1 write_posseq, write_config, write_note, write_end
  logical*1 tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9 ,tag10, &
            tag11,tag12,tag13,tag14,tag15,tag16,tag17,tag18,tag19,tag20

  if (write_note) then
    tag1 = .false.; tag2 = .false.; tag3 = .false.; tag4 = .false.; tag5 = .false.;
    tag6 = .false.; tag7 = .false.; tag8 = .false.; tag9 = .false.; tag10= .false.;
    tag11= .false.; tag12= .false.; tag13= .false.; tag14= .false.; tag15= .false.;
    tag16= .false.; tag17= .false.; tag18= .false.; tag19= .false.; tag20= .false.;
    if (write_file .eq. 'pos') then
      tag1 = .true.; tag4 = .true.; tag7 = .true.; tag8 = .true.; tag9 = .true.; tag11 = .true.; tag12 = .true.;
    else if (write_file .eq. 'kin') then
      tag6 = .true.; tag7 = .true.; tag10 = .true.; tag13 = .true.; tag14 = .true.;
    else if (write_file .eq. 'rck') then
      tag2 = .true.; tag15 = .true.;
    else if (write_file .eq. 'ztd') then
      tag2 = .true.; tag16 = .true.;
    else if (write_file .eq. 'htg') then
      tag3 = .true.; tag17 = .true.;
    else if (write_file .eq. 'amb') then
      tag18 = .true.;
    endif
  endif

  if (write_posseq) then
    if (write_config) then
      write(lfn,'(a4,56x,a)') SITE%name, 'STATION'
      if (SITE%skd(1:1) .eq. 'S') then
        write(lfn,'(a6,5x,3f10.6,19x,a)') 'Static', (SITE%dx0(i), i=1, 3), 'POS MODE/PRIORI (meter)'
      else if (SITE%skd(1:1) .eq. 'K') then
        write(lfn,'(a9,2x,3f10.6,19x,a)') 'Kinematic', (SITE%dx0(i), i=1, 3), 'POS MODE/PRIORI (meter)'
      else if (SITE%skd(1:1) .eq. 'F') then
        write(lfn,'(a11,3f10.6,19x,a)') 'Quasi-fixed', (SITE%dx0(i), i=1, 3), 'POS MODE/PRIORI (meter)'
      else
        msg = SITE%skd
        goto 100
      endif
      if (LCF%edit(1:3) .eq. 'YES' .or. LCF%edit(1:2) .eq. 'NO') then
        write(lfn,'(a15,45x,a)') LCF%edit, 'OBS STRICT EDITING'
      else
        msg = LCF%edit
        goto 100
      endif
      call mjd2date(LCF%jd_beg, LCF%sod_beg, iy, imon, id, ih, imin, sec)
      write(lfn,'(i4,4i3,f6.2,38x,a)') iy, imon, id, ih, imin, sec, 'OBS FIRST EPOCH'
      call mjd2date(LCF%jd_end, LCF%sod_end, iy, imon, id, ih, imin, sec)
      write(lfn,'(i4,4i3,f6.2,38x,a)') iy, imon, id, ih, imin, sec, 'OBS LAST EPOCH'
      if (count(OB%typuse(1,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(1,1),OB%typuse(1,2),OB%typuse(1,3),OB%typuse(1,4), 'OBS TYPE (GPS)'
      endif
      if (count(OB%typuse(2,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(2,1),OB%typuse(2,2),OB%typuse(2,3),OB%typuse(2,4), 'OBS TYPE (GLONASS)'
      endif
      if (count(OB%typuse(3,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(3,1),OB%typuse(3,2),OB%typuse(3,3),OB%typuse(3,4), 'OBS TYPE (Galileo)'
      endif
      if (count(OB%typuse(4,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(4,1),OB%typuse(4,2),OB%typuse(4,3),OB%typuse(4,4), 'OBS TYPE (BDS)'
      endif
      if (count(OB%typuse(5,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(5,1),OB%typuse(5,2),OB%typuse(5,3),OB%typuse(5,4), 'OBS TYPE (QZSS)'
      endif
      write(lfn,'(f8.2,52x,a)') LCF%dintv, 'OBS INTERVAL (sec)'
      write(lfn,'(f8.2,52x,a)') SITE%cutoff/PI*180.d0, 'OBS MASK ANGLE (deg)'      
      write(lfn,'(f8.2,52x,a)') SITE%sigr, 'MEASUREMENT NOISE PSEUDORANGE (1-SIGMA, meter)'
      write(lfn,'(f8.2,52x,a)') SITE%sigp, 'MEASUREMENT NOISE CARRIER PHASE (1-SIGMA, cycle)'
      write(lfn,'(a60,a)') LCF%flnorb_real, 'SAT ORBIT'
      write(lfn,'(a60,a)') LCF%flnsck_real, 'SAT CLOCK'
      write(lfn,'(a60,a)') LCF%flnfcb_real, 'SAT BIAS'
      if (LCF%attuse) then
        write(lfn,'(a60,a)') LCF%flnatt_real, 'SAT ATTITUDE'
      else
        write(lfn,'(a7,53x,a)') 'Default', 'SAT ATTITUDE'
      endif
      write(lfn,'(a60,a)') LCF%flnerp_real, 'TABLE ERP'
      write(lfn,'(a60,a)') LCF%flnatx_real, 'TABLE ANTEX'
      write(lfn,'(a15,45x,a)') LCF%ztdmod, 'TROP ZENITH'
      write(lfn,'(a15,45x,a)') LCF%htgmod, 'TROP GRADIENT'
      if (LCF%lioh) then 
        write(lfn,'(a3,57x,a)') 'YES', 'IONO 2ND'
      else
        write(lfn,'(a2,58x,a)') 'NO', 'IONO 2ND'
      endif
      line1 = ''; line2 = ''; line3 = '';
      if (index(LCF%tide,'SOLID').ne.0) line1 = 'SOLID'
      if (index(LCF%tide,'POLE').ne.0) line2 = 'POLE'
      if (index(LCF%tide,'OCEAN').ne.0) line3 = 'OCEAN'
      if (.not. LCF%otluse) line3 = ''
      write(lfn,'(3(a5,1x),42x,a)') trim(line1),trim(line2),trim(line3), 'TIDES'
      if (LCF%nconG+LCF%nconE+LCF%nconC2+LCF%nconC3+LCF%nconJ .gt. 0) then
        line1 = 'GPS '
        line3 = 'GAL '
        line4 = 'BDS2'
        line5 = 'BDS3'
        line6 = 'QZSS'
        write(lfn,'(a3,5(2x,a4,i5),2x,a)') 'YES', line1, LCF%nconG, line3, LCF%nconE, &
              line4, LCF%nconC2, line5, LCF%nconC3, line6, LCF%nconJ, 'AMB FIXING'
      else
        write(lfn,'(a2,58x,a)') 'NO', 'AMB FIXING'
      endif
      if (LCF%fcbuse) then
        if (write_file .eq. 'amb') then
          write (lfn, '(i5,55x,a)') LCF%fcbnprn, '# OF AMB RESOLVABLE SAT'
          isat = 1
          do while (isat .le. LCF%fcbnprn)
            if (LCF%fcbnprn - isat + 1 .ge. 15) then
              write (lfn, '(15(a3,1x),a)') (LCF%fcbprn(i), i=isat, isat + 14), 'AMB RESOLVABLE SATELLITES'
              isat = isat + 15
            else
              line = ' '
              write (line, '(15(a3,1x))') (LCF%fcbprn(i), i=isat, LCF%fcbnprn)
              write (lfn, '(a)') line//'AMB RESOLVABLE SATELLITES'
              exit
            endif
          enddo
        endif
      endif
      write(lfn,'(f8.2,52x,a)') LCF%minsec_common, 'AMB DURATION (sec)'
      write(lfn,'(f8.2,52x,a)') LCF%cutoff, 'AMB CUTOFF (deg)'
      write(lfn,'(3f8.2,36x,a)') LCF%wl_maxdev, LCF%wl_maxsig, LCF%wl_alpha, 'AMB WIDELANE'
      write(lfn,'(3f8.2,36x,a)') LCF%nl_maxdev, LCF%nl_maxsig, LCF%nl_alpha, 'AMB NARROWLANE'
      write(lfn,'(2(i5,3x),2f8.2,28x,a)') LCF%maxdel, LCF%minsav, LCF%chisq, LCF%ratio, 'AMB SEARCH'
    endif
    if (write_note) then
      write(lfn,'(a23,37x,a)') 'Start Field Description', 'COMMENT'
      if (tag1) then
        write(lfn,'(a4,56x,a)') 'Name', 'STATION NAME'
      endif
      if (tag2) then
        write(lfn,'(a4,56x,a)') 'Year', 'YEAR (GPS TIME)'
        write(lfn,'(a3,57x,a)') 'Mon', 'MONTH (GPS TIME)'
        write(lfn,'(a3,57x,a)') 'Day', 'DAY (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'Hour', 'HOUR (GPS TIME)'
        write(lfn,'(a3,57x,a)') 'Min', 'MINUTE (GPS TIME)'
        write(lfn,'(a3,57x,a)') 'Sec', 'SECOND (GPS TIME)'
      endif
      if (tag3) then
        write(lfn,'(a5,55x,a)') 'YearS', 'START YEAR (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'MonS', 'START MONTH (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'DayS', 'START DAY (GPS TIME)'
        write(lfn,'(a5,55x,a)') 'HourS', 'START HOUR (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'MinS', 'START MINUTE (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'SecS', 'START SECOND (GPS TIME)'
        write(lfn,'(a5,55x,a)') 'YearE', 'END YEAR (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'MonE', 'END MONTH (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'DayE', 'ENDT DAY (GPS TIME)'
        write(lfn,'(a5,55x,a)') 'HourE', 'END HOUR (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'MinE', 'END MINUTE (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'SecE', 'END SECOND (GPS TIME)'
      endif
      if (tag4) then
        write(lfn,'(a3,57x,a)') 'Mjd', 'MODIFIED JULIAN DAY'
      endif
      if (tag5) then
        write(lfn,'(a4,56x,a)') 'MjdS', 'START MODIFIED JULIAN DAY'
        write(lfn,'(a4,56x,a)') 'MjdE', 'END MODIFIED JULIAN DAY'
      endif
      if (tag6) then
        write(lfn,'(a3,57x,a)') 'Mjd', 'MODIFIED JULIAN DAY'
        write(lfn,'(a3,57x,a)') 'Sod', 'SECOND OF DAY'
      endif
      if (tag7) then
        write(lfn,'(a1,59x,a)') 'X', 'X COORDINATE (meter)'
        write(lfn,'(a1,59x,a)') 'Y', 'Y COORDINATE (meter)'
        write(lfn,'(a1,59x,a)') 'Z', 'Z COORDINATE (meter)'
      endif
      if (tag8) then
        write(lfn,'(a2,58x,a)') 'Sx', 'DIAGONAL COFACTOR OF X COORDINATE'
        write(lfn,'(a2,58x,a)') 'Sy', 'DIAGONAL COFACTOR OF Y COORDINATE'
        write(lfn,'(a2,58x,a)') 'Sz', 'DIAGONAL COFACTOR OF Z COORDINATE'
      endif
      if (tag9) then
        write(lfn,'(a3,57x,a)') 'Rxy', 'OFF-DIAGONAL COFACTOR OF X AND Y COORDINATES'
        write(lfn,'(a3,57x,a)') 'Rxz', 'OFF-DIAGONAL COFACTOR OF X AND Z COORDINATES'
        write(lfn,'(a3,57x,a)') 'Ryz', 'OFF-DIAGONAL COFACTOR OF Y AND Z COORDINATES'
      endif
      if (tag10) then
        write(lfn,'(a8,52x,a)') 'Latitude', 'LATITUDE OF WGS-84 ELLIPSOID (deg)'
        write(lfn,'(a9,51x,a)') 'Longitude', 'LONTITUDE OF WGS-84 ELLIPSOID (deg)'
        write(lfn,'(a6,54x,a)') 'Height', 'HEIGHT OF WGS-84 ELLIPSOID (meter)'
      endif
      if (tag11) then
        write(lfn,'(a4,56x,a)') 'Sig0', 'SQUARE ROOT OF VARIANCE FACTOR (meter)'
      endif
      if (tag12) then
        write(lfn,'(a4,56x,a)') 'Nobs', 'NUMBER OF OBSERVATIONS'
      endif
      if (tag13) then
        write(lfn,'(a13,47x,a)') 'Nsat/GREC2C3J', 'NUMBER OF AVAIABLE SATELLITES (ALL/GPS/GLONASS/Galileo/BDS-2/BDS-3/QZSS)'
      endif
      if (tag14) then
        write(lfn,'(a4,56x,a)') 'PDOP', 'POSITION DILUTION OF PRECISION'
      endif
      if (tag15) then
        write(lfn,'(a8,52x,a)') 'RCK(GPS)', 'GPS RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a12,48x,a)') 'RCK(GLONASS)', 'GLONASS RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a12,48x,a)') 'RCK(Galileo)', 'Galileo RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a10,50x,a)') 'RCK(BDS-2)', 'BDS-2 RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a10,50x,a)') 'RCK(BDS-3)', 'BDS-3 RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a9,51x,a)') 'RCK(QZSS)', 'QZSS RECEIVER CLOCK ERROR (meter)'
      endif
      if (tag16) then
        write(lfn,'(a3,57x,a)') 'ZDD', 'ZENITH DRY DELAY (meter)'
        write(lfn,'(a6,54x,a)') 'ZWDini', 'INITIAL ZENITH WET DELAY (meter)'
        write(lfn,'(a3,57x,a)') 'ZWDcor', 'ZENITH WET DELAY CORRECTION (meter)'
      endif
      if (tag17) then
        write(lfn,'(a7,53x,a)') 'HTGCini', 'INITIAL N-S TROPOSPHERE GRADIENT (meter)'
        write(lfn,'(a7,53x,a)') 'HTGCcor', 'N-S TROPOSPHERE GRADIENT CORRECTION (meter)'
        write(lfn,'(a7,53x,a)') 'HTGSini', 'INITIAL E-W TROPOSPHERE GRADIENT (meter)'
        write(lfn,'(a7,53x,a)') 'HTGScor', 'E-W TROPOSPHERE GRADIENT CORRECTION (meter)'
      endif
      if (tag18) then
        write(lfn,'(a3,57x,a)') 'PRN', 'SATELLITE PRN'
        write(lfn,'(a5,55x,a)') 'IFamb', 'IONOSPHERE-FREE COMBINATION AMBIGUITY (cycle)'
        write(lfn,'(a5,55x,a)') 'WLamb', 'WIDE-LANE AMBIGUITY (cycle)'
        write(lfn,'(a5,55x,a)') 'SigIF', 'SAMPLE STANDARD DEVIATION OF IFamb (cycle)'
        write(lfn,'(a5,55x,a)') 'SigWL', 'SAMPLE STANDARD DEVIATION OF WLamb (cycle)'
        write(lfn,'(a4,56x,a)') 'Elev', 'MEAN ELEVATION ANGLE (deg)'
      endif
      write(lfn,'(a21,39x,a)') 'End Field Description', 'COMMENT'
    endif
    if (write_end) then
      write(lfn,'(60x,a)') 'END OF HEADER'
    endif
    if (write_note) then
      if (write_file .eq. 'pos') then
        write(lfn,'(a5,1x,a11,3a15,7a25,a15)') '*Name', 'Mjd', 'X', 'Y', 'Z', 'Sx', 'Sy', 'Sz', 'Rxy', 'Rxz', 'Ryz', 'Sig0', 'Nobs'
      else if (write_file .eq. 'kin') then
        write(lfn,'(a1,a4,a10,2x,3a13,2a16,a13,a25,a7)') '*','Mjd', 'Sod', 'X', 'Y', 'Z', 'Latitude', 'Longitude', 'Height', &
             'Nsat/GREC2C3J', 'PDOP'
      else if (write_file .eq. 'rck') then
        write(lfn,'(a1,a5,4a6,a10,6a17)') '*','Year', 'Mon', 'Day', 'Hour', 'Min', 'Sec', &
                         'RCK(GPS)', 'RCK(GLONASS)', 'RCK(Galileo)', 'RCK(BDS-2)', 'RCK(BDS-3)', 'RCK(QZSS)'
      else if (write_file .eq. 'ztd') then
        write(lfn,'(a1,a5,4a6,a10,3a11)') '*','Year', 'Mon', 'Day', 'Hour', 'Min', 'Sec', 'ZDD', 'ZWDini', 'ZWDcor'
      else if (write_file .eq. 'htg') then
        write(lfn,'(2(5a6,a10),4a11)') '*YearS', 'MonS', 'DayS', 'HourS', 'MinS', 'SecS', &
                                        'YearE', 'MonE', 'DayE', 'HourE', 'MinE', 'SecE', 'HTGCini', 'HTGCcor', 'HTGSini', 'HTGScor'
      else if (write_file .eq. 'amb') then
        write(lfn,'(a4,2a22,2a18,2a9,a6)') '*PRN', 'IFamb', 'WLamb', 'MjdS', 'MjdE', 'SigIF', 'SigWL', 'Elev'
      endif
    endif
  else
    if (write_note) then
      if (write_file .eq. 'pos') then
        write(lfn,'(a5,1x,a11,3a15,7a25,a15)') '*Name', 'Mjd', 'X', 'Y', 'Z', 'Sx', 'Sy', 'Sz', 'Rxy', 'Rxz', 'Ryz', 'Sig0', 'Nobs'
      else if (write_file .eq. 'kin') then
        write(lfn,'(a1,a4,a10,2x,3a13,2a16,a13,a25,a7)') '*','Mjd', 'Sod', 'X', 'Y', 'Z', 'Latitude', 'Longitude', 'Height', &
             'Nsat/GREC2C3J', 'PDOP'
      else if (write_file .eq. 'rck') then
        write(lfn,'(a1,a5,4a6,a10,6a17)') '*','Year', 'Mon', 'Day', 'Hour', 'Min', 'Sec', &
                         'RCK(GPS)', 'RCK(GLONASS)', 'RCK(Galileo)', 'RCK(BDS-2)', 'RCK(BDS-3)', 'RCK(QZSS)'
      else if (write_file .eq. 'ztd') then
        write(lfn,'(a1,a5,4a6,a10,3a11)') '*','Year', 'Mon', 'Day', 'Hour', 'Min', 'Sec', 'ZDD', 'ZWDini', 'ZWDcor'
      else if (write_file .eq. 'htg') then
        write(lfn,'(2(5a6,a10),4a11)') '*YearS', 'MonS', 'DayS', 'HourS', 'MinS', 'SecS', &
                                        'YearE', 'MonE', 'DayE', 'HourE', 'MinE', 'SecE', 'HTGCini', 'HTGCcor', 'HTGSini', 'HTGScor'
      else if (write_file .eq. 'amb') then
        write(lfn,'(a4,2a22,2a18,2a9,a6)') '*PRN', 'IFamb', 'WLamb', 'MjdS', 'MjdE', 'SigIF', 'SigWL', 'Elev'
      endif
    endif
    if (write_end) then
      write(lfn,'(60x,a)') 'END OF HEADER'
    endif
    if (write_note) then
      write(lfn,'(a21,39x,a)') 'End Field Description', 'COMMENT'
      if (tag18) then
        write(lfn,'(a4,56x,a)') 'Elev', 'MEAN ELEVATION ANGLE (deg)'
        write(lfn,'(a5,55x,a)') 'SigWL', 'SAMPLE STANDARD DEVIATION OF WLamb (cycle)'
        write(lfn,'(a5,55x,a)') 'SigIF', 'SAMPLE STANDARD DEVIATION OF IFamb (cycle)'
        write(lfn,'(a5,55x,a)') 'WLamb', 'WIDE-LANE AMBIGUITY (cycle)'
        write(lfn,'(a5,55x,a)') 'IFamb', 'IONOSPHERE-FREE COMBINATION AMBIGUITY (cycle)'
        write(lfn,'(a3,57x,a)') 'PRN', 'SATELLITE PRN'
      endif
      if (tag17) then
        write(lfn,'(a7,53x,a)') 'HTGScor', 'E-W TROPOSPHERE GRADIENT CORRECTION (meter)'
        write(lfn,'(a7,53x,a)') 'HTGSini', 'INITIAL E-W TROPOSPHERE GRADIEN (meter)'
        write(lfn,'(a7,53x,a)') 'HTGCcor', 'N-S TROPOSPHERE GRADIENT CORRECTION (meter)'
        write(lfn,'(a7,53x,a)') 'HTGCini', 'INITIAL N-S TROPOSPHERE GRADIENT (meter)'
      endif
      if (tag16) then
        write(lfn,'(a6,54x,a)') 'ZWDcor', 'ZENITH WET DELAY CORRECTION (meter)'
        write(lfn,'(a6,54x,a)') 'ZWDini', 'INITIAL ZENITH WET DELAY (meter)'
        write(lfn,'(a3,57x,a)') 'ZDD', 'ZENITH DRY DELAY (meter)'
      endif
      if (tag15) then
        write(lfn,'(a9,51x,a)') 'RCK(QZSS)', 'QZSS RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a10,50x,a)') 'RCK(BDS-3)', 'BDS-3 RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a10,50x,a)') 'RCK(BDS-2)', 'BDS-2 RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a12,48x,a)') 'RCK(Galileo)', 'Galileo RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a12,48x,a)') 'RCK(GLONASS)', 'GLONASS RECEIVER CLOCK ERROR (meter)'
        write(lfn,'(a8,52x,a)') 'RCK(GPS)', 'GPS RECEIVER CLOCK ERROR (meter)'
      endif
      if (tag14) then
        write(lfn,'(a4,56x,a)') 'PDOP', 'POSITION DILUTION OF PRECISION'
      endif
      if (tag13) then
        write(lfn,'(a13,47x,a)') 'Nsat/GREC2C3J', 'NUMBER OF AVAIABLE SATELLITES (ALL/GPS/GLONASS/Galileo/BDS-2/BDS-3/QZSS)'
      endif
      if (tag12) then
        write(lfn,'(a4,56x,a)') 'Nobs', 'NUMBER OF OBSERVATIONS'
      endif
      if (tag11) then
        write(lfn,'(a4,56x,a)') 'Sig0', 'SQUARE ROOT OF VARIANCE FACTOR (meter)'
      endif
      if (tag10) then
        write(lfn,'(a6,54x,a)') 'Height', 'HEIGHT OF WGS-84 ELLIPSOID (meter)'
        write(lfn,'(a9,51x,a)') 'Longitude', 'LONGITUDE OF WGS-84 ELLIPSOID (deg)'
        write(lfn,'(a8,52x,a)') 'Latitude', 'LATITUDE OF WGS-84 ELLIPSOID (deg)'
      endif
      if (tag9) then
        write(lfn,'(a3,57x,a)') 'Ryz', 'OFF-DIAGONAL COFACTOR OF Y AND Z COORDINATES'
        write(lfn,'(a3,57x,a)') 'Rxz', 'OFF-DIAGONAL COFACTOR OF X AND Z COORDINATES'
        write(lfn,'(a3,57x,a)') 'Rxy', 'OFF-DIAGONAL COFACTOR OF X AND Y COORDINATES'
      endif
      if (tag8) then
        write(lfn,'(a2,58x,a)') 'Sz', 'DIAGONAL COFACTOR OF Z COORDINATE'
        write(lfn,'(a2,58x,a)') 'Sy', 'DIAGONAL COFACTOR OF Y COORDINATE'
        write(lfn,'(a2,58x,a)') 'Sx', 'DIAGONAL COFACTOR OF X COORDINATE'
      endif
      if (tag7) then
        write(lfn,'(a1,59x,a)') 'Z', 'Z COORDINATE (meter)'
        write(lfn,'(a1,59x,a)') 'Y', 'Y COORDINATE (meter)'
        write(lfn,'(a1,59x,a)') 'X', 'X COORDINATE (meter)'
      endif
      if (tag6) then
        write(lfn,'(a3,57x,a)') 'Sod', 'SECOND OF DAY'
        write(lfn,'(a3,57x,a)') 'Mjd', 'MODIFIED JULIAN DAY'
      endif
      if (tag5) then
        write(lfn,'(a4,56x,a)') 'MjdE', 'END MODIFIED JULIAN DAY'
        write(lfn,'(a4,56x,a)') 'MjdS', 'START MODIFIED JULIAN DAY'
      endif
      if (tag4) then
        write(lfn,'(a3,57x,a)') 'Mjd', 'MODIFIED JULIAN DAY'
      endif
      if (tag3) then
        write(lfn,'(a4,56x,a)') 'SecE', 'END SECOND (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'MinE', 'END MINUTE (GPS TIME)'
        write(lfn,'(a5,55x,a)') 'HourE', 'END HOUR (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'DayE', 'END DAY (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'MonE', 'END MONTH (GPS TIME)'
        write(lfn,'(a5,55x,a)') 'YearE', 'END YEAR (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'SecS', 'START SECOND (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'MinS', 'START MINUTE (GPS TIME)'
        write(lfn,'(a5,55x,a)') 'HourS', 'START HOUR (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'DayS', 'START DAY (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'MonS', 'START MONTH (GPS TIME)'
        write(lfn,'(a5,55x,a)') 'YearS', 'START YEAR (GPS TIME)'
      endif
      if (tag2) then        
        write(lfn,'(a3,57x,a)') 'Sec', 'SECOND (GPS TIME)'
        write(lfn,'(a3,57x,a)') 'Min', 'MINUTE (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'Hour', 'HOUR (GPS TIME)'
        write(lfn,'(a3,57x,a)') 'Day', 'DAY (GPS TIME)'
        write(lfn,'(a3,57x,a)') 'Mon', 'MONTH (GPS TIME)'
        write(lfn,'(a4,56x,a)') 'Year', 'YEAR (GPS TIME)'
      endif
      if (tag1) then
        write(lfn,'(a4,56x,a)') 'Name', 'STATION NAME'
      endif
      write(lfn,'(a23,37x,a)') 'Start Field Description', 'COMMENT'
    endif
    if (write_config) then
      write(lfn,'(2(i5,3x),2f8.2,28x,a)') LCF%maxdel, LCF%minsav, LCF%chisq, LCF%ratio, 'AMB SEARCH'
      write(lfn,'(3f8.2,36x,a)') LCF%nl_maxdev, LCF%nl_maxsig, LCF%nl_alpha, 'AMB NARROWLANE'
      write(lfn,'(3f8.2,36x,a)') LCF%wl_maxdev, LCF%wl_maxsig, LCF%wl_alpha, 'AMB WIDELANE'
      write(lfn,'(f8.2,52x,a)') LCF%cutoff, 'AMB CUTOFF (deg)'
      write(lfn,'(f8.2,52x,a)') LCF%minsec_common, 'AMB DURATION (sec)'
      if (LCF%nconG+LCF%nconE+LCF%nconC2+LCF%nconC3+LCF%nconJ .gt. 0) then
        line1 = 'GPS '
        line3 = 'GAL '
        line4 = 'BDS2'
        line5 = 'BDS3'
        line6 = 'QZSS'
        write(lfn,'(a3,5(2x,a4,i5),2x,a)') 'YES', line1, LCF%nconG, line3, LCF%nconE, &
              line4, LCF%nconC2, line5, LCF%nconC3, line6, LCF%nconJ, 'AMB FIXING'
      else
        write(lfn,'(a2,58x,a)') 'NO', 'AMB FIXING'
      endif
      line1 = ''; line2 = ''; line3 = '';
      if (index(LCF%tide,'SOLID').ne.0) line1 = 'SOLID'
      if (index(LCF%tide,'POLE').ne.0) line2 = 'POLE'
      if (index(LCF%tide,'OCEAN').ne.0) line3 = 'OCEAN'
      if (.not. LCF%otluse) line3 = ''
      write(lfn,'(3(a5,1x),42x,a)') trim(line1),trim(line2),trim(line3), 'TIDES'
      if (LCF%lioh) then 
        write(lfn,'(a3,57x,a)') 'YES', 'IONO 2ND'
      else
        write(lfn,'(a2,58x,a)') 'NO', 'IONO 2ND'
      endif
      write(lfn,'(a15,45x,a)') LCF%htgmod, 'TROP GRADIENT'
      write(lfn,'(a15,45x,a)') LCF%ztdmod, 'TROP ZENITH'
      write(lfn,'(a60,a)') LCF%flnatx_real, 'TABLE ANTEX'
      write(lfn,'(a60,a)') LCF%flnerp_real, 'TABLE ERP'
      if (LCF%attuse) then
        write(lfn,'(a60,a)') LCF%flnatt_real, 'SAT ATTITUDE'
      else
        write(lfn,'(a7,53x,a)') 'Default', 'SAT ATTITUDE'
      endif
      write(lfn,'(a60,a)') LCF%flnfcb_real, 'SAT BIAS'
      write(lfn,'(a60,a)') LCF%flnsck_real, 'SAT CLOCK'
      write(lfn,'(a60,a)') LCF%flnorb_real, 'SAT ORBIT'
      write(lfn,'(f8.2,52x,a)') SITE%sigp, 'MEASUREMENT NOISE CARRIER PHASE (1-SIGMA, cycle)'
      write(lfn,'(f8.2,52x,a)') SITE%sigr, 'MEASUREMENT NOISE PSEUDORANGE (1-SIGMA, meter)'     
      write(lfn,'(f8.2,52x,a)') SITE%cutoff/PI*180.d0, 'OBS MASK ANGLE (deg)'
      write(lfn,'(f8.2,52x,a)') LCF%dintv, 'OBS INTERVAL (sec)'
      if (count(OB%typuse(5,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(5,1),OB%typuse(5,2),OB%typuse(5,3),OB%typuse(5,4), 'OBS TYPE (QZSS)'
      endif
      if (count(OB%typuse(4,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(4,1),OB%typuse(4,2),OB%typuse(4,3),OB%typuse(4,4), 'OBS TYPE (BDS)'
      endif
      if (count(OB%typuse(3,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(3,1),OB%typuse(3,2),OB%typuse(3,3),OB%typuse(3,4), 'OBS TYPE (Galileo)'
      endif
      if (count(OB%typuse(2,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(2,1),OB%typuse(2,2),OB%typuse(2,3),OB%typuse(2,4), 'OBS TYPE (GLONASS)'
      endif
      if (count(OB%typuse(1,1:4) .ne. '') .eq. 4) then
        write(lfn,'(4(a3,1x),44x,a)') OB%typuse(1,1),OB%typuse(1,2),OB%typuse(1,3),OB%typuse(1,4), 'OBS TYPE (GPS)'
      endif
      call mjd2date(LCF%jd_end, LCF%sod_end, iy, imon, id, ih, imin, sec)
      write(lfn,'(i4,4i3,f6.2,38x,a)') iy, imon, id, ih, imin, sec, 'OBS LAST EPOCH'
      call mjd2date(LCF%jd_beg, LCF%sod_beg, iy, imon, id, ih, imin, sec)
      write(lfn,'(i4,4i3,f6.2,38x,a)') iy, imon, id, ih, imin, sec, 'OBS FIRST EPOCH'
      if (LCF%edit(1:3) .eq. 'YES' .or. LCF%edit(1:2) .eq. 'NO') then
        write(lfn,'(a15,45x,a)') LCF%edit, 'OBS STRICT EDITING'
      else
        msg = LCF%edit
        goto 100
      endif
      if (SITE%skd(1:1) .eq. 'S') then
        write(lfn,'(a6,5x,3f10.6,19x,a)') 'Static', (SITE%dx0(i), i=1, 3), 'POS MODE/PRIORI (meter)'
      else if (SITE%skd(1:1) .eq. 'K') then
        write(lfn,'(a9,2x,3f10.6,19x,a)') 'Kinematic', (SITE%dx0(i), i=1, 3), 'POS MODE/PRIORI (meter)'
      else if (SITE%skd(1:1) .eq. 'F') then
        write(lfn,'(a11,3f10.6,19x,a)') 'Quasi-fixed', (SITE%dx0(i), i=1, 3), 'POS MODE/PRIORI (meter)'
      else
        msg = SITE%skd
        goto 100
      endif
      write(lfn,'(a4,56x,a)') SITE%name, 'STATION'
    endif
  endif

  return
100 write (*, '(2a)') '***ERROR(lsq_wrt_header): wrong arguments ', trim(msg)
  call exit(1)  
end