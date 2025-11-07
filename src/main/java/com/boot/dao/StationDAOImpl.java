package com.boot.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Repository;

import com.boot.dto.StationDTO;
import com.boot.dto.StationListItem;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class StationDAOImpl implements StationDAO {
  private final SqlSessionTemplate sql;  // MyBatisConfig에서 주입

  private static final String NS = "com.example.air.mapper.StationMapper.";

  @Override
  public StationDTO findByName(String stationName) {
    return sql.selectOne(NS + "findByName", stationName);
  }

  @Override
  public void insert(StationDTO station) {
    sql.insert(NS + "insertStation", station);
  }

  @Override
  public List<StationListItem> selectInBbox(double south, double west, double north, double east) {
    Map<String,Object> p = new HashMap<>();
    p.put("south", south); p.put("west", west); p.put("north", north); p.put("east", east);
    return sql.selectList(NS + "selectStationsInBbox", p);
  }
}