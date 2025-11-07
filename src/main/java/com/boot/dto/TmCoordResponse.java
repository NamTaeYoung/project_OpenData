package com.boot.dto;

import lombok.Data;

import java.util.List;

@Data
public class TmCoordResponse {
    private List<Document> documents;
    private Meta meta;

    @Data
    public static class Document {
        private double x;  // TM_X
        private double y;  // TM_Y
    }

    @Data
    public static class Meta {
        private int totalCount;
    }

    public double getX() {
        return documents != null && !documents.isEmpty() ? documents.get(0).getX() : 0;
    }

    public double getY() {
        return documents != null && !documents.isEmpty() ? documents.get(0).getY() : 0;
    }
}
