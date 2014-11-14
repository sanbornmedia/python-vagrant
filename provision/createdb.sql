drop database IF EXISTS appdb;
create database appdb;
grant ALL on appdb.* to appuser@'localhost' identified by 'apppass';
